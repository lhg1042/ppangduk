<%@page import="ppangduk.MemberDAO"%>
<%@page import="ppangduk.MemberDTO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<fmt:requestEncoding value="utf-8" />

<jsp:useBean id="memberVo" class="ppangduk.MemberVO" />
<jsp:setProperty property="*" name="memberVo" />

<c:choose>
	<c:when test="${empty memberVo.id || empty memberVo.pw || empty memberVo.name || empty memberVo.nick}">
		<script>alert('필수 정보입니다.'); history.back();</script>
	</c:when>
	<c:when test="${empty memberVo.email}">
		<script>alert('이메일 인증은 필수입니다.'); history.back();</script>
	</c:when>
	<c:when test="${memberVo.pw != memberVo.confirmPw }">
		<script>alert('두 패스워드가 일치하지 않습니다.'); history.back();</script>
	</c:when>
	<c:otherwise>
		<%
		MemberDAO memberDao = new MemberDAO(); 
		pageContext.setAttribute("memberDao", memberDao);
		
		String id = request.getParameter("id");
		String email = request.getParameter("email");
		
		MemberDTO check1 = memberDao.selectId(id+email);
		%>
		<c:set var="check2" value="${memberDao.selectNick(memberVo.nick) }"/>
		<c:choose>
			<c:when test="${not empty check1 }" >
				<script>alert('이미 가입된 이메일입니다.'); location.href='registForm.jsp';</script>
			</c:when>
			<c:when test="${not empty check2 }">
				<script>alert('이미 등록된 닉네임입니다.'); location.href='registForm.jsp';</script>
			</c:when>
			<c:otherwise>
				<%
					memberVo.setId(id+email);
				%>
				${memberDao.insert(memberVo) }
				<script>alert('회원 가입 완료'); location.href='community/community_home.jsp';</script>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>
<%--
<%    
	
	request.setCharacterEncoding("UTF-8"); 
	String id = request.getParameter("id");
	String email = request.getParameter("email");
	String pw = request.getParameter("pw");
	String confirm_pw = request.getParameter("confirm_pw");
	String name = request.getParameter("name");
	String nick = request.getParameter("nick");

	if(id == "" || pw == "" || name == "" || nick == "") {
		out.print("<script>alert('필수 정보입니다.'); history.back();</script>");
		return;
	} 
	if (email == "") {
		out.print("<script>alert('이메일 인증은 필수입니다.'); history.back();</script>");
	} 
	if (! pw.equals(confirm_pw)) {
		out.print("script>alert('두 패스워드가 일치하지 않습니다.'); history.back();</script>");
		return;
	}
	
	MemberDAO memberDao = new MemberDAO();
	MemberDTO check1 = memberDao.selectId(id+email);
	MemberDTO check2 = memberDao.selectNick(nick);
	if(check1 == null && check2 == null) {
		MemberDTO member = new MemberDTO();
		member.setId(id+email);
		member.setPw(pw);
		member.setName(name);
		member.setNick(nick);
		memberDao.insert(member);
		out.print("<script>alert('회원 가입 완료'); location.href='community_home.jsp';</script>");
	} else if (check1 != null){
		out.print("<script>alert('이미 가입된 이메일입니다.'); location.back();</script>");
	} else if (check2 != null) {
		out.print("<script>alert('이미 등록된 닉네임입니다.'); location.back();</script>");
	} else {
		out.print("<script>alert('회원 가입 실패'); location.back();</script>");
	}
	
%>
--%>