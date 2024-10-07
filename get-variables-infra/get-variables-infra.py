import os
import boto3
import datetime
import logging
from boto3.dynamodb.conditions import Key, Attr
import pytz



class DownloadFiles():
    def __init__(self, dynamo_table, region_name, bucket_name, timezone ):
        self.dynamo_table = dynamo_table
        self.region_name = region_name
        self.bucket_name = bucket_name
        self.timezone = timezone
        self.current_time = datetime.datetime.now(self.timezone)
        self.glue_services = {'glue': [],'cloudwatch':[],'tables': [],'databases': [],'crawlers': []}
        self.services_created = ["glue","cloudwatch","tables","databases","crawlers"]
        self.path_s3_ = []

        self.aws_key = os.getenv("AWS_ACCESS_KEY_ID")
        self.aws_secret = os.getenv("AWS_SECRET_ACCESS_KEY")
        self.dynamodb = boto3.resource('dynamodb', self.region_name)
        self.s3_session = boto3.client('s3')
        self.table = self.dynamodb.Table(self.dynamo_table)

    
    def get_records_dynamo(self):
        time_five_ago = self.current_time - datetime.timedelta(minutes=5) 
        print(time_five_ago)
        transform_date_five = time_five_ago.strftime('%Y-%m-%d %H:%M:%S')
        transform_current_time = self.current_time.strftime('%Y-%m-%d %H:%M:%S')
        try:
            response = self.table.scan(
                FilterExpression=Attr('process-files').begins_with('variable-')
            )
            variables=response.get('Items', [])
            for item in variables:
                if "UpdateDate" in item:
                    # print('UpdateDate',item['UpdateDate'])
                    # print('transform_date_five',transform_date_five)
                    # print('transform_current_time',transform_current_time)
                    if transform_date_five < item['UpdateDate'] < transform_current_time:
                        self.path_s3_.append(item['S3_key'])
                else:
                    # print('CreationDate',item['CreationDate'])
                    if transform_date_five < item['CreationDate'] < transform_current_time:
                        self.path_s3_.append(item['S3_key'])
            return self.path_s3_
        except Exception as e:
            logging.info(f"Error al obtener registros de DynamoDB: {str(e)}")

    
    def create_json_output(self ):
        current_glue_type = None
        current_config = {}
        for s3_key in self.path_s3_:
            # Obtener el contenido del archivo .env
            env_content = self.get_env_from_s3(s3_key, self.bucket_name)
            # Parsear el contenido del archivo .env
            lines = env_content.splitlines()
            for line in lines:
                line = line.strip()  # Limpiar espacios
                #validar linea a linea el servicio
                for service in self.services_created:
                    if f"#{service}" in line :
                        if current_config and current_glue_type:
                            self.glue_services[current_glue_type].append(current_config)
                        current_config = {}
                        current_glue_type = f"{service}"
                    elif "=" in line:
                        key, value = line.split('=', 1)  # Permitir '=' en los valores
                        current_config[key.strip()] = value.strip()
            # Verificar antes de añadir al final de la iteración
            if current_config and current_glue_type:
                self.glue_services[current_glue_type].append(current_config)
            current_config = {}
    

    def get_env_from_s3(self, s3_key, bucket_name):
        response = self.s3_session.get_object(Bucket=bucket_name, Key=s3_key)
        content = response['Body'].read().decode('utf-8')
        return content
    
    
    def create_file_infra(self):
        output_content = ""
        for service in self.services_created:
            output_content += f"glue_{service} = [\n"
            for table in self.glue_services[service]:
                output_content += "    {\n"
                for key, value in table.items():
                    output_content += f"        {key} = \"{value}\"\n"
                output_content += "    },\n"
            output_content = output_content.rstrip(",\n") + "\n"   #Eliminar la última coma y nueva línea
            output_content += "]\n"

        with open('config-infra.tfvars', 'w') as file:
            file.write(output_content)

    
    def set_output(self, output_name, value):
        if "GITHUB_OUTPUT" in os.environ:
            with open(os.environ["GITHUB_OUTPUT"], "a") as variable:
                variable.write(f"{output_name}={value}")



if __name__ == "__main__":
    logging.info("--------------------------------")
    logging.info("Proceso iniciado")
    logging.info("--------------------------------")
    # Nombre del bucket de S3
    bucket_name = 'process-etl-glue-prod'
    # Nombre de la Tabla en DynamoDB
    dynamodb_table = 'state-files-process'
    region_name = 'us-east-2'
    guatemala_timezone = pytz.timezone('America/Guatemala')
    download_files = DownloadFiles(dynamodb_table, 
                                   region_name, 
                                   bucket_name, 
                                   guatemala_timezone)    
    
    process_data=download_files.get_records_dynamo()
    if process_data:
        download_files.create_json_output()
        download_files.create_file_infra()
        print("Process")
    else:
        download_files.set_output("status", "empty")
        print("EMPTY")

    
   