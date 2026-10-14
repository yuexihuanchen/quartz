为什么要有SpringBoot：
	为了简化Spring中的配置和统一各种依赖的版本，SpringBoot诞生了！
什么是spring:
	Spring作为J2EE的轻量级代替品，让我们无需开发重量级的Enterprise JavaBean（EJB），通过依赖注入和面向切面编程，使用简单的Java对象（POJO）即可实现EJB的功能。
	虽然Spring的组件代码是轻量级的，但它的配置却是重量级的。即使后来Spring引入了基于注解的组件扫描和基于Java的配置，让它看上去简洁不少，但Spring还是需要不少配置。除此之外，项目的依赖管理也很麻烦，我们无法确保各个版本的依赖都能兼容。
	 ==Spring框架的主要功能是**依赖注入**或**控制反转**(IoC)==
SpringBoot从本质上来说就是Spring有一下三个核心：
	- 自动配置：对于很多Spring应用程序常见的应用功能，SpringBoot能自动提供相关配置，集成功能开发者仅需很少的配置。
	- 起步依赖：告诉SpringBoot需要什么功能，它就能引入对应的库，无需考虑该功能依赖库的版本问题。
	- Actuator：可以深入了解SpringBoot应用程序内部情况，比如创建了哪些Bean、自动配置的决策、应用程序的状态信息等。

Spring Boot是Spring Framework的模块。它允许我们构建具有最少配置或零配置的独立应用程序。如果我们要开发一个简单的基于Spring的应用程序或RESTful服务，最好使用它。

项目结构
	mall-tiny-boot
	├─pom.xml # Maven构建文件
	└─src
	   ├─main
	   │  ├─java
	   │  │  └─MallTinyApplication.java # 应用程序启动类
	   │  └─resources
	   │     └─application.yml # SpringBoot配置文件
	   └─test
	       └─java
	           └─MallTinyApplicationTests.java # 基本的集成测试类
应用启动类：
	`MallTinyApplication`在SpringBoot应用中有配置和引导的作用，通过`@SpringBootApplication`注解开启组件扫描和自动配置，通过`SpringApplication.run()`引导应用程序启动
	
	`@SpringBootApplication`注解是三个注解的结合体，拥有以下三个注解的功能：
	- `@Configuration`：用于声明Spring中的Java配置；
	- `@ComponentScan`：启用组件扫描，当我们使用`@Component`注解声明组件时，会自动发现并注册为Spring应用上下文中的Bean；
	- `@EnableAutoConfiguration`：开启SpringBoot自动配置功能，简化配置编写
测试应用
	可以使用`@SpringBootTest`注解来创建Spring应用上下文，通过`@Test`注解来声明一个测试方法。
编写应用配置
	可以在`application.yml`文件中进行配置，比如微调下端口号

![[springbootlayer.png]]

![[spirngbootflow.png]]