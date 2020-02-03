package com.mr.ssm.test;

import java.util.UUID;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.mr.ssm.bean.Department;
import com.mr.ssm.bean.Employee;
import com.mr.ssm.dao.DepartmentMapper;
import com.mr.ssm.dao.EmployeeMapper;

/**   
 * @ClassName:     MapperTest   
 * @Description:   测试dao层的工作 
 * 推荐使用Spring项目自带的Spring单元测试，可以自动注入我们需要的 组件
 * @author:        mr
 * @date:          2020年2月1日 下午7:46:22     
 */

// 1.导入SpringTest模块
// 2. ContextConfiguration指定Spring配置文件的位置
// 3. 直接@Autowired需要的组件

// junit的注解@RunWith表明使用的单元测试模块，这里使用的是Spring的
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {
	
	@Autowired
	DepartmentMapper departmentMapper;
	
	@Autowired
	EmployeeMapper employeeMapper;
	
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Test
	public void testCRUD() {
//		// 1. 创建Spring IOC容器
//		ApplicationContext ioc = new ClassPathXmlApplicationContext("application.xml");
//		// 2. 从容器中获取mapper
//		DepartmentMapper bean = ioc.getBean(DepartmentMapper.class);
	
		System.out.println(departmentMapper);
		
		// 1. 插入部门
		departmentMapper.insertSelective(new Department(null, "研发部"));
		departmentMapper.insertSelective(new Department(null, "测试部"));
		
		// 2.员工插入
		employeeMapper.insertSelective(new Employee(null, "Jim", "M", "Jim@xxx.com", 1));
		
		// 3. 批量插入多个员工,使用可以执行批量操作的sqlSession
		// 如果用for就是1000次
		
		// 这个是一次
		EmployeeMapper mapper = sqlSessionTemplate.getMapper(EmployeeMapper.class);
		for(int i = 0; i < 1000; i++) {
			String uid = UUID.randomUUID().toString().substring(0,5);
			mapper.insertSelective(new Employee(null, uid, "M", uid + "@xxx.com", i % 2));
		}
	}
}
