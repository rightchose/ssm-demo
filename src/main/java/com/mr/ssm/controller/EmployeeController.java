package com.mr.ssm.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.mr.ssm.bean.Employee;
import com.mr.ssm.bean.Msg;
import com.mr.ssm.service.EmployeeService;

/**   
 * @author:        mr
 * @date:          2020年2月1日 下午10:22:50     
 */
@Controller
public class EmployeeController {

	@Autowired
	EmployeeService employeeService;
	
	
	// post请求
	@PostMapping("/emp")
	@ResponseBody
	// form提交的表单信息会被自动封装
	public Msg saveEmp(Employee employee) {
		employeeService.saveEmp(employee);
		return Msg.success();
	}
	
	
	// @ResponseBody注解将返回的数据变为json
	// 但需要导入jackspn包
	@RequestMapping("/emps")
	@ResponseBody
	public Msg getEmpsWithJson(
			@RequestParam(value="pn", defaultValue = "1") Integer pn) {
		// 会查出很多员工数据，要分页
		// 引入PageHelper分页插件
		// 在查询之前只需要调用,传入页码，以及每页的大小
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		// 使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		// PageInfo封装了分页信息，包裹我们查询的数据
		PageInfo page = new PageInfo(emps, 5);	// 连续显示的页数,和之前的5不一样
		return Msg.success().add("pageInfo", page);
	}
	

	
//	@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn", defaultValue = "1") Integer pn,
				Model model) {
		// 会查出很多员工数据，要分页
		// 引入PageHelper分页插件
		// 在查询之前只需要调用,传入页码，以及每页的大小
		PageHelper.startPage(pn, 5);
		// startPage后面紧跟的这个查询就是一个分页查询
		List<Employee> emps = employeeService.getAll();
		// 使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		// PageInfo封装了分页信息，包裹我们查询的数据
		PageInfo page = new PageInfo(emps, 5);	// 连续显示的页数,和之前的5不一样
		model.addAttribute("pageInfo", page);
		return "list";	// 到list.jsp,没有就返回“list”
	}
	
}
