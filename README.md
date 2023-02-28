# Spring Boot 3 Native Image sample from Docker scratch

- Only Linux amd64 is supported at the moment!

## Build and run

```shell
# Build the native image from scratch
docker build -t native-sample .

# Let's look at the layers
dive native-sample
# ┃ ● Layers ┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ │ Current Layer Contents ├───────────────────────────────────────────
# Cmp   Size  Command                                                   Permission     UID:GID       Size  Filetree
#        0 B  FROM a9b99f883087b4c                                      -rwxr-xr-x         0:0      17 MB  ├── native-sample
#      17 MB  COPY /app/build/native/nativeCompile/native-sample . # bu drwxr-xr-x         0:0        0 B  └── tmp
# 
# │ Layer Details ├────────────────────────────────────────────────────


# Or only inspect size of the image
docker inspect -f "{{ .Size }}" native-sample | numfmt --to=si
# 17M

# Run the image
docker run -it --rm -p 8080:8080 native-sample
#   .   ____          _            __ _ _
#  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
# ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
#  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
#   '  |____| .__|_| |_|_| |_\__, | / / / /
#  =========|_|==============|___/=/_/_/_/
#  :: Spring Boot ::                (v3.0.3)
# 
# 2023-02-28T21:10:09.282Z  INFO 1 --- [           main] l.s.n.NativeSampleApplication            : Starting AOT-processed NativeSampleApplication using Java 17.0.6 with PID 1 (/native-sample started by ? in /)
# 2023-02-28T21:10:09.282Z  INFO 1 --- [           main] l.s.n.NativeSampleApplication            : No active profile set, falling back to 1 default profile: "default"
# 2023-02-28T21:10:09.293Z  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat initialized with port(s): 8080 (http)
# 2023-02-28T21:10:09.293Z  INFO 1 --- [           main] o.apache.catalina.core.StandardService   : Starting service [Tomcat]
# 2023-02-28T21:10:09.293Z  INFO 1 --- [           main] o.apache.catalina.core.StandardEngine    : Starting Servlet engine: [Apache Tomcat/10.1.5]
# 2023-02-28T21:10:09.298Z  INFO 1 --- [           main] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring embedded WebApplicationContext
# 2023-02-28T21:10:09.298Z  INFO 1 --- [           main] w.s.c.ServletWebServerApplicationContext : Root WebApplicationContext: initialization completed in 16 ms
# 2023-02-28T21:10:09.327Z  WARN 1 --- [           main] i.m.c.i.binder.jvm.JvmGcMetrics          : GC notifications will not be available because MemoryPoolMXBeans are not provided by the JVM
# 2023-02-28T21:10:09.329Z  INFO 1 --- [           main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 1 endpoint(s) beneath base path '/actuator'
# 2023-02-28T21:10:09.332Z  INFO 1 --- [           main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
# 2023-02-28T21:10:09.332Z  INFO 1 --- [           main] l.s.n.NativeSampleApplication            : Started NativeSampleApplication in 0.056 seconds (process running for 0.057)

# Navigate to http://localhost:8080/actuator/health
```

## Results

- Build time: 202 s (3.3 min)
- Image size: 17 MB
- Startup time: 56 ms
- Memory consumption at the beginning: 124MB

Computer specs:
- CPU: Intel i5-6600K
- Memory: 48 GB, DDR4
- OS: Linux 5.10
- Docker: 23.0.1

## Spring recommended way

```shell
# Use Cloud Native Buildpacks
./gradlew bootBuildImage
# Size 98M

# Run the image
docker run -it --rm -p 8080:8080 native-sample
```