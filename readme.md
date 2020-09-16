## Usage
```shell
docker run -i -t -d --name=kanboard -v /your/kanboard/path/kanboard:/var/www/app -p 9980:80  masker/kanboard:latest
```


> Thanks For
- [kanboard official docker configurations](https://github.com/kanboard/kanboard/tree/master/docker)
- [The s6-svscan program](https://skarnet.org/software/s6/s6-svscan.html)
