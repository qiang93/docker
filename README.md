说明:</p>
该镜像同时包含nginx+php,参考传入参数变量启动不同服务

扩展:</p>
centos版本为编译安装,添加扩展需要修改Dockerfile,修改版本和扩展

debian版本为docker官方Dockerfile改进,添加扩展可阅读此帮助文档:https://docs.docker.com/samples/library/php/

使用:</p>
Build</p>
	docker build -t lnp:1.1 .
</p>
Run</p>
	参考example文件示例docker-compose
