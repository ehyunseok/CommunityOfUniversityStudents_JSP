<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.mail.Transport"%>
<%@ page import="javax.mail.Message"%>
<%@ page import="javax.mail.Address"%>
<%@ page import="javax.mail.internet.MimeMessage"%>
<%@ page import="javax.mail.internet.InternetAddress"%>
<%@ page import="javax.mail.Authenticator"%>
<%@ page import="javax.mail.Session"%>
<%@ page import="java.util.Properties"%>
<%@ page import="user.UserDao"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>
<%
	UserDao userDao = new UserDao();
	String userID = null;
	if(session.getAttribute("userID") == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userLogin.jsp'");
		script.println("</script>");
		script.close();
		return;
	}

	boolean emailChecked = userDao.getUserEmailChecked(userID);
	if(emailChecked == true){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증된 회원입니다.');");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
	
	// 사용자에게 요청을 UTF-8 인코딩처리하여 받는다.
	request.setCharacterEncoding("UTF-8");
	
	String reportTitle = null;
	String reportContent = null;
	// 입력받은 제목과 내용을 저장함
	if(request.getParameter("reportTitle") != null){
		reportTitle = request.getParameter("reportTitle");
	}
	if(request.getParameter("reportContent") != null){
		reportContent = request.getParameter("reportContent");
	}
	if(reportTitle == null || reportContent == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('모든 항목을 입력하세요.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	
	String host = "http://localhost:8080/BookFriends/";
	//관리자 이메일로 신고 메일 전송
	String to = "yhdaneys@gmail.com";
	userID=(String)session.getAttribute("userID");
	String from = userID + "@eucr.com";
	
	String subject = "Ehyun Univ Course Review에서 접수된 신고 메일입니다.";
	String content = "신고자: " + userID 
					+"<br>제목: " + reportTitle
					+"<br>내용: " + reportContent;
		
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.gmail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.ssl.protocols", "TLSv1.2");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try {
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF-8");
		Transport.send(msg);
	} catch(Exception e){
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	PrintWriter script = response.getWriter();
	script.println("<script>");
	script.println("alert('신고가 접수되었습니다.');");
	script.println("history.back();");
	script.println("</script>");
	script.close();
	return;
%>