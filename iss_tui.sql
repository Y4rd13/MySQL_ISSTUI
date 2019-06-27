import csv, json, os, mysql.connector
from mysql.connector import errorcode

#constantes
HOST="host"
USER="user"
PASSWD="password"
DB="database"
PORT="port"
inicio=0

#dictionary vacío
configuracion={}

while inicio==0:
	inicio+=1
	#MENU INICIO: argumentos de conexión definidos por el usuario
	print("\n/////////////////////////////////////////////////////////")
	print("\t>>>BIENVENIDO A MYSQL-CONNECTOR-PYTHON<<<")
	print("////////////////////////////////////////////////////////")
	
	print("\n\tIngreso de datos de configuracion de conexión")
	print("\t1. Manual")
	print("\t2. Automático (se ingresará datos por default)")
	opcion_configuracion=input("\t>Ingrese opción numérica: ")

	if opcion_configuracion.isnumeric()==True:
		if opcion_configuracion=="1":
			print("\n\tIngrese los siguientes datos")
			host=input("\n\t>HOST: ")
			user=input("\t>USER: ")
			password=input("\t>PASSWORD: ")
			database=input("\t>DATABASE: ")
			port=input("\t>PORT: ")

		elif opcion_configuracion=="2":
			database=input("\t>DATABASE: ")
			host="localhost"
			user="root"
			password=""
			port="3306"
		else:
			print("\n\tdebe ingresar una opción correcta")
			inicio=0 #LUEGO ARREGLAR
			
	else:
		print("\n\tdebe ingresar un número")
		inicio=0 #LUEGO ARREGLAR

	
	#los argumentos de conexión definidos en un diccionario [con keys:values] para su mejor manipulación
	#otra opción --> configuracion=mysql.connector.connect(option_files='/etc/mysql/connectors.cnf')
	configuracion[HOST]=host
	configuracion[USER]=user
	configuracion[PASSWD]=password
	configuracion[DB]=database
	configuracion[PORT]=port
	
	#conectando a la DB
	try:
		conexion_db=mysql.connector.connect(**configuracion)
		print("\n\t>>>CONECTADO EXITOSAMENTE A LA DATABASE:",database)
		print("\t>>>Bienvenido",user)

		#cursor (nos permite ejecutar y usar los comandos SQL en la sesión actual)
		#nos da la ventaja de tener multiples y separados ambientes de trabajo a traves de la misma conexión a la base de datos.
		cursor=conexion_db.cursor()

		while inicio==1:
			inicio+=1
			archivo=input("\n\tIngrese nombre del archivo.csv o path (ej. C:/users/user/desktop/carpeta/archivo.csv): ")
			if os.path.exists(archivo):
				with open(archivo,"r") as csv_file:
					csv_data=csv.reader(csv_file,delimiter=" ")
					print("\n\t>>LEYENDO",archivo) 
					for row in csv_data:
						print("\t",row) #imprime una lista de todos los valores por cada linea 

						#separar el statement sql para 
						#statement_sql_import=
						#cursor.execute("INSERT INTO registros (clave_profesor, nombre, apellido, fecha, hora_de_ingreso, hora_de_salida, sala) VALUES (%s,%s,%s,%s,%s,%s,%s)",(row[0], row[1],row[2],row[3],row[4],row[5],row[6],row[7]))
						#print("datos csv insertados a la db")
			
			else:
				print("\n\t>>El archivo no existe")
				inicio=1

		#ejecutar la query 
		cursor.execute("SELECT * FROM registros") #(execute: prepara la sentencia)
		rows=cursor.fetchall()#(presenta el resultado | FETCH ALL)
		for i in rows:
			print("\n\t>>REGISTROS DATABASE:")
			print("\t",i)

		#los datos (ingresados) se perpetrar(commit) a la base de datos
		conexion_db.commit()

	#para error de conexión
	except mysql.connector.Error as err:
	  if err.errno==errorcode.ER_ACCESS_DENIED_ERROR:
	    print("\n\t>>USUARIO o PASSWORD incorrectos")
	    inicio=0
	  elif err.errno==errorcode.ER_BAD_DB_ERROR:
	    print("\n\t>>La DATABASE no existe")
	    inicio=0
	  else:
	    print("\n>>>ERROR DE MYSQL (conexión o parámetros):")
	    print("\t>>No es posible conectar MySQL server")
	    print("\t>>error:",err)
	    inicio=0
    
	else:
	  while inicio==2:
	  	print("\n¿Desea realizar otra operación?")
	  	print("\t1. Sí")
	  	print("\t2. No")
	  	operacion=input("Ingrese opción numérica: ")

	  	if operacion.isnumeric()==True:
	  		if operacion=="1":
	  			inicio=0
	  		elif operacion=="2":
	  			#cerrando cursor
	  			print("\n>>Cerrando el cursor...")
	  			cursor.close()
	  			#cerrando conexión
	  			print(">>Desconectando de la DATABASE",database)
	  			conexion_db.close()
	  			break
	  		else:
	  			print("\n\terror: opción incorrecta")
	  			inicio=2
	  	else:
	  		print("\n\t>>error: debe ingresar un número")
	  		incio=2
