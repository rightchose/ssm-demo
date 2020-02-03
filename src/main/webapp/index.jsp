<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- 引入标签库 -->
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>员工列表</title>
<!-- 设置APP_PATH -->
<%
	pageContext.setAttribute("APP_PATH", request.getContextPath());
%>
	<!-- 不以/开始的相对路径，是以当前路径为基准，经常容易出问题
		以/开始的相对路径，是以服务器的路径为标准(http://localhost:3306/crud)，
		需要加上项目名
		http://localhost:3306/crud
	 -->
	<link rel="stylesheet" href="${ APP_PATH }/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" >
	<script type="text/javascript" src="${ APP_PATH }/static/js/jquery-3.4-1.js"></script>
	<script type="text/javascript" src="${ APP_PATH }/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

	<!-- 员工添加 -->
	<!-- Modal -->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="myModalLabel">员工添加</h4>
	      </div>
	      <div class="modal-body">
	      
	      	<!-- 表单 -->
	        <form class="form-horizontal">
			  <div class="form-group">
			    <label for="empName_add_input" class="col-sm-2 control-label">员工姓名</label>
			    <div class="col-sm-10">
			      <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="员工姓名">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email_add_input" class="col-sm-2 control-label">员工邮箱</label>
			    <div class="col-sm-10">
			      <input type="email" name="email" class="form-control" id="email_add_input" placeholder="员工邮箱">
			      <span class="help-block"></span>
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email_add_input" class="col-sm-2 control-label">员工性别</label>
			    <div class="col-sm-10">
					<label class="radio-inline">
					  <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked">男
					</label>
					<label class="radio-inline">
						<input type="radio" name="gender" id="gender2_add_input" value="F"> 女
					</label>			      
			    </div>
			  </div>
			  <div class="form-group">
			    <label for="email_add_input" class="col-sm-2 control-label">员工部门</label>
			    <div class="col-sm-4">
			    	<!--  部门提交id即可 -->
					<select class="form-control" name="dId" id="dept_add_select">
					</select>		      
			    </div>
			  </div>	
			</form>
			
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
	        <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
	      </div>
	    </div>
	  </div>
	</div>

	<!-- 显示页面 -->
	<div class="container">
		<!-- 标题 -->
		<div class="row">
			<div class="col-md-12">
				<h1>SSM-CRUD</h1>
			</div>
		</div>
		<!-- 按钮 -->
		<div class="row">
			<div class="col-md-4 col-md-offset-8">
				<button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
				<button class="btn btn-danger">删除</button>
			</div>
		</div>
		<!-- 显示表格 -->
		<div class="row">
			<div class="col-md-12">
				<table class="table table-hover" id="employee_table">
					<thead>
						<tr>
		                    <th>#</th>
		                    <th>empName</th>
		                    <th>gender</th>
		                    <th>email</th>
		                    <th>deptName</th>
		                    <th>操作</th>
		                </tr>
					</thead>
					<tbody>
					
					</tbody>
	                
				</table>
			</div>
		</div>
		<!-- 显示分页信息 -->
		<div class="row">
			<!-- 分页文字信息 -->
			<div class="col-md-6" id="page_info_area">
			</div>
			<!-- 分页条导航 -->
			<div class="col-md-6" id="page_info_nav">
				
			</div>
		</div>
	</div>

	<script type="text/javascript">
		var totalRecord;
		
	    $(function () {
	        to_page(1);
	    });
	
	    function to_page(pn) {
	        $.ajax({
	            url: "${APP_PATH}/emps",
	            data: "pn=" + pn,
	            type: "GET",
	            success: function (result) {
	                console.log(result);
	                build_emps_table(result);
	                build_page_info(result);
	                build_page_nav(result)
	            }
	        });
	    }
	
		
		
		function build_emps_table(result){

			$("#employee_table tbody").empty();
			var emps = result.extend.pageInfo.list;
			
			console.log(emps);
			$.each(emps, function(index, item){
				// 员工姓名id
				var empIdTd = $("<td></td>").append(item.empId);
				var empNameTd = $("<td></td>").append(item.empName);
				var genderTd = $("<td></td>").append(item.gender == "M"? "男" : "女");			
				var emailTd = $("<td></td>").append(item.email);
				var deptNameTd = $("<td></td>").append(item.department == null ? "" : item.department.deptName);
				
				var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
								.append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
				var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
								.append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
				
				var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
				
				console.log(item);
				$("<tr></tr>").append(empIdTd)
					.append(empNameTd)
					.append(genderTd)
					.append(emailTd)
					.append(deptNameTd)
					.append(btnTd)
					.appendTo("#employee_table tbody");
			});
		}
		
		// 解析显示分页信息 
		function build_page_info(result){
			$("#page_info_area").empty();
			
			 $("#page_info_area").append("当前"
			            + result.extend.pageInfo.pageNum
			            + "第页,总"
			            + result.extend.pageInfo.pages
			            + "页,总共"
			            + result.extend.pageInfo.total
			            + "有条记录");
			totalRecord = result.extend.pageInfo.total;
		}
		// 解析显示分页条
		function build_page_nav(result){

			$("#page_info_nav").empty();
			
			var ul = $("<ul></ul>").addClass("pagination");
			
			var firstPageLi = $("<li></li>")
            	.append($("<a></a>").append("首页").attr("href", "#"));
			var prePageLi = $("<li></li>")
	            .append($("<a></a>").append("&laquo;"));
	        if (!result.extend.pageInfo.hasPreviousPage) {
	            firstPageLi.addClass("disabled");
	            prePageLi.addClass("disabled");
	        } else {
	            firstPageLi.click(function () {
	                to_page(1);
	            });
	            prePageLi.click(function () {
	                to_page(result.extend.pageInfo.pageNum - 1);
	            });
	        }
	        ul.append(firstPageLi).append(prePageLi);
	        
	        
	        var nextPageLi = $("<li></li>")
	            .append($("<a></a>").append("&raquo;"));
	        var lastPageLi = $("<li></li>")
	            .append($("<a></a>").append("尾页").attr("href", "#"));
	        if (!result.extend.pageInfo.hasNextPage) {
	            lastPageLi.addClass("disabled");
	            nextPageLi.addClass("disabled");
	        } else {
	            lastPageLi.click(function () {
	                to_page(result.extend.pageInfo.pages);
	            });
	            nextPageLi.click(function () {
	                to_page(result.extend.pageInfo.pageNum + 1);
	            });
	        }
	        
	        $.each(result.extend.pageInfo.navigatepageNums, function (index, item) {
	            var numLi = $("<li></li>")
	                .append($("<a></a>").append(item));
	            if (result.extend.pageInfo.pageNum == item) {
	                numLi.addClass("active");
	            }
	            numLi.click(function () {
	                to_page(item)
	            });
	            ul.append(numLi);
	        });

	        ul.append(nextPageLi).append(lastPageLi);
	        
	        var navEle = $("<nav></nav>").append(ul);

	        $("#page_info_nav").append(navEle);
	        
		}
		
		$("#emp_add_modal_btn").click(function(){
			$("#dept_add_select").empty();
			// 发送ajax请求填补部门信息，查出部门信息，显示在下拉列表
			getDepts();
			
			$("#myModal").modal({
				backdrop: "static"
			});
		});
		
		// 查出所有的部门信息，并显示在下拉列表
		function getDepts(){
			$.ajax({
				url: "${APP_PATH}/depts",
				type: "GET",
				success: function(result){
					console.log(result);
					$("#dept_add_select").append("");
					$.each(result.extend.depts, function(){
						var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
						optionEle.appendTo("#dept_add_select");
					});
				}
			});
		}
		
		// 校验表单数据
		function validate_add_form(){
			// 1. 拿到校验数据
			var empName = $("#empName_add_input").val();
			var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
			if(!regName.test(empName)){
				alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
			}
			
			// 2.校验邮箱
			var email = $("#email_add_input").val();
	        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
	        if (!regEmail.test(email)) {
	            show_validate_msg("#email_add_input", "error", "邮箱格式输入错误");
	            return false;
	        } else {
	            show_validate_msg("#email_add_input", "success", "");
	        }
	        return true;
		}
		
		// 保存新增员工
		$("#emp_save_btn").click(function(){
			
			// 要先对表单数据进行校验
			
			// 1.发送ajax请求保存员工
			$.ajax({
				url: "${APP_PATH}/emp",
				type: "POST",
				// 将表单里的内容序列化
				data: $("#myModal form").serialize(),
				success: function(result){
					//alert(result.msg);
					// 员工保存成功
					// 1.关闭modal框
					$("#myModal").modal("hide");
					// 2.来到最后一页
					to_page(totalRecord);
				}
			});
		});
		
	</script>

</body>
</html>