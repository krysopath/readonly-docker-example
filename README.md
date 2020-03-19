# run container processes as random user

If you still own the randoms user group, then you can
use that to allow writes.

demo:
```
make read-only
```

see this:
```
$ make read-only
docker stop service-a service-b
service-a
service-b
sudo rm -rf ./volume
mkdir -p volume/service-{a,b}
sudo chmod -R g=rwx ./volume
docker build -t ro:latest .
Sending build context to Docker daemon  22.02kB
Step 1/6 : FROM alpine
 ---> e7d92cdc71fe
Step 2/6 : COPY run.sh /bin/run.sh
 ---> 6a76a48c3e69
Step 3/6 : WORKDIR /volume
 ---> Running in 1b5d89ae0af8
Removing intermediate container 1b5d89ae0af8
 ---> 5011f25acc30
Step 4/6 : RUN chown -R 1337:1337 /volume
 ---> Running in 4d6ecf961ee5
Removing intermediate container 4d6ecf961ee5
 ---> 6985710d8a03
Step 5/6 : USER 1337:1337
 ---> Running in 9188d8712283
Removing intermediate container 9188d8712283
 ---> 217145228809
Step 6/6 : CMD /bin/run.sh
 ---> Running in 791a94150634
Removing intermediate container 791a94150634
 ---> 5845f48fd1b3
Successfully built 5845f48fd1b3
Successfully tagged ro:latest
rand_uid=$RANDOM &&\
sudo chown -R $rand_uid:1337 ./volume/service-a && \
docker run \
	-u $rand_uid:1337 \
	--workdir /volume \
	--name service-a \
	--rm \
	--read-only \
	-d \
	-v /home/gve/src/docker-read-only/volume/service-a:/volume:rw ro:latest
a2fd55aebc2e3c3611ff643581fbda5c7c815549d0c0abe6c860cd0a774badad
rand_uid=$RANDOM &&\
sudo chown -R $rand_uid:1337 ./volume/service-b && \
docker run \
	-u $rand_uid:1337 \
	--workdir /volume \
	--name service-b \
	--rm \
	--read-only \
	-d \
	-v /home/gve/src/docker-read-only/volume/service-b:/volume:rw ro:latest
5dae32344686256a7165ca478bc16c5ba41a028b4139b88b03fc639b63b5a414
test it!

```


Confirm this
```
$ tree volume/
volume/
├── service-a
│   └── success
└── service-b
    └── success

2 directories, 2 files
```

Or
```
$ ls -lanR volume/
volume/:
total 16
drwxrwxr-x 4  1000 1000 4096 Mär 19 03:32 .
drwxr-xr-x 3  1000 1000 4096 Mär 19 03:32 ..
drwxrwxr-x 2  8149 1337 4096 Mär 19 03:32 service-a
drwxrwxr-x 2 16137 1337 4096 Mär 19 03:32 service-b

volume/service-a:
total 12
drwxrwxr-x 2 8149 1337 4096 Mär 19 03:32 .
drwxrwxr-x 4 1000 1000 4096 Mär 19 03:32 ..
-rw-r--r-- 1 8149 1337 3840 Mär 19 03:34 success

volume/service-b:
total 12
drwxrwxr-x 2 16137 1337 4096 Mär 19 03:32 .
drwxrwxr-x 4  1000 1000 4096 Mär 19 03:32 ..
-rw-r--r-- 1 16137 1337 3920 Mär 19 03:34 success

```


Such configuration allows containers to run read-only while using a volume as
spooling directory, for common write operations. This also allows to put
configuration files that got generated into this volume; That can help with
pure docker in certain situations.
