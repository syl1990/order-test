#!/usr/bin/env bash
#编译+部署order站点

#需要配置如下参数
# 项目路径, 在Execute Shell中配置项目路径, pwd 就可以获得该项目路径
# export jenkins_home=这个jenkins任务在部署机器上的路径

# 输入你的环境上tomcat的全路径
# export TOMCAT_HOME=tomcat在部署机器上的路径

### base 函数
killTomcat()
{
    pid=`ps -ef|grep tomcat|grep java|awk '{print $2}'`
    echo "tomcat Id list :$pid"
    if [ "$pid" = "" ]
    then
      echo "no tomcat pid alive"
    else
      kill -9 $pid
    fi
}
cd $jenkins_home
mvn clean install

# 停tomcat
killTomcat

# 删除原有工程
rm -rf $TOMCAT_HOME/webapps/ROOT
rm -f $TOMCAT_HOME/webapps/ROOT.war
rm -f $TOMCAT_HOME/webapps/order.war

# 复制新的工程
cp $jenkins_home/target/order.war $TOMCAT_HOME/webapps/

cd $TOMCAT_HOME/webapps/
mv order.war ROOT.war

# 启动Tomcat
cd $TOMCAT_HOME/
sh bin/startup.sh



