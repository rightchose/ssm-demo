package com.mr.ssm.test;


import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.DefaultMockMvcBuilder;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.github.pagehelper.PageInfo;
import com.mr.ssm.bean.Employee;

/**   
 * 使用Spring测试模块提供的测试请求功能，测试crud请求的正确性
 *	Spring4 测试的时候需要servlet3.0支持
 * @author:        mr
 * @date:          2020年2月1日 下午11:32:20     
 */

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
// 这里还要加上SpringMvc的配置信息
@ContextConfiguration(locations = {"classpath:applicationContext.xml", "file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MvcTest {
	
	// 将ioc容器注入还需要一个注解
	// 传入springmvc的ioc
	@Autowired
	WebApplicationContext context;
	
	// 虚拟的mvc请求，获取处理结果
	MockMvc mockMvc;
	
	// 这里引入的是junit的@Before
	@Before
	public void initMockMvc() {
		mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
	}
	
	@Test
	public void testPage() throws Exception {
		// 模拟请求, reuslt返回值
		MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "1")).andReturn();
		
		// 请求成功以后，请求域中会有pageInfo,我们可以去除pageInfo,进行验证
		MockHttpServletRequest request = result.getRequest();
		PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
	
		System.out.println("当前页码 " + pi.getPageNum());
		System.out.println("总页码 " + pi.getPages());
		System.out.println("总记录数 " + pi.getTotal());
		System.out.println("在页面需要连续现实的页码");
		
		int[] nums = pi.getNavigatepageNums();
		for(int i : nums) {
			System.out.println(" " + i);
		}
		
		// 获取员工数据
		List<Employee> list = pi.getList();
		for(Employee employee : list) {
			System.out.println("ID, " + employee.getEmpId() + "==>Name " + employee.getEmpName());
		}
	}
	
}
