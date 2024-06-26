<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="user.UserDao"%>
<%@ page import="recruit.RecruitDao"%>
<%@ page import="recruit.RecruitDto"%>
<%@ page import="file.FileDao"%>
<%@ page import="file.FileDto"%>
<%@ page import="java.sql.Timestamp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv='X-UA-Compatible' content='IE=edge'>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>독서친구</title>
    <link rel="stylesheet" href="../css/bootstrap.min.css">
    <link rel="stylesheet" href="../css/custom.css">
    <style>
        #editor {
            width: auto;
            margin: 0 auto;
            min-height: 300px;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    
    <!-- Quill styleSheet -->
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet" />
    
    
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 해주세요.');");
        script.println("location.href='userLogin.jsp'");
        script.println("</script>");
        script.close();
        return;
    }

    boolean emailChecked = new UserDao().getUserEmailChecked(userID);
    if (emailChecked == false) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("location.href='emailSendConfirm.jsp'");
        script.println("</script>");
        script.close();
        return;
    }
    
    String recruitID = request.getParameter("recruitID");
    System.out.println("recuritID="+recruitID);
    if(recruitID == null){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('recruitID is null.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
    
    RecruitDao recruitDao = new RecruitDao();
    RecruitDto recruit = new RecruitDao().getPost(recruitID);
    if(recruit == null ){
    	PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('게시글을 불러올 수 없습니다.');");
        script.println("history.back();");
        script.println("</script>");
        script.close();
        return;
    }
    
%>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <a class="navbar-brand" href="../index.jsp">독서친구</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div id="navbar" class="collapse navbar-collapse">
        <ul class="navbar-nav mr-auto">
            <li class="nav-item">
                <a class="nav-link" href="../index.jsp">메인</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="../review/bookReview.jsp">서평</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="../board/board.jsp">자유게시판</a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="../recruit/recruit.jsp"><b>독서모임</b></a>
            </li>
			<li class="nav-item">
				<a class="nav-link" href="../marekt/market.jsp">중고장터</a>
			</li>
			<li class="nav-item">
				<a class="nav-link" href="../chat/chat.jsp">채팅</a>
			</li>           
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
                    회원관리
                </a>
                <div class="dropdown-menu" aria-labelledby="dropdown">
                    <a class="dropdown-item" style="color: green;"><b><%= userID %></b> 님 환영합니다.</a>
                    <a class="dropdown-item" href="../user/userLogoutAction.jsp">로그아웃</a>
                </div>
            </li>
        </ul>
    </div>
</nav>

<section class="container mt-3 mb-5">
    <div class="">
        <div class="card-body bg-light">
            <form action="<%= request.getContextPath() %>/recruitUpdate" method="post" enctype="multipart/form-data">
			    <input type="hidden" name="recruitID" value="<%= recruit.getRecruitID() %>">
			    <div class="form-group">
			        <input type="text" name="recruitTitle" id="recruitTitle" class="border-bottom-0 border border-secondary rounded"
			               style="height: 50px; width:100%; border: none; background:white;" value="<%= recruit.getRecruitTitle() %>">
			    </div>
			    <div class="form-group">
			        <div class="custom-control custom-radio custom-control-inline">
					  	<input type="radio" id="customRadioInline1" name="recruitStatus" class="custom-control-input" value="모집중">
					  	<label class="custom-control-label" for="customRadioInline1">모집중</label>
					</div>
					<div class="custom-control custom-radio custom-control-inline">
					  	<input type="radio" id="customRadioInline2" name="recruitStatus" class="custom-control-input" value="모집완료">
					 	<label class="custom-control-label" for="customRadioInline2">모집완료</label>
					</div>
			    </div>
			    <div class="form-group">
			        <div id="editor"></div>
			        <input type="hidden" id="quill_html" name="recruitContent" maxlength="2048" value="">
			    </div>
			    <div class="row ml-auto mt-3">
			        <a class="btn btn-outline-secondary mr-1" href="./recruit.jsp">취소</a>
			        <button type="submit" class="btn btn-primary">작성</button>
			    </div>
			</form>
        </div>
    </div>
</section>


<!-- Include the Quill library -->
<script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>

<!-- Initialize Quill editor -->
<script>
const quill = new Quill('#editor', {
	modules:{
		toolbar: [	//툴바 구성 custom
			[{header:[1,2,3, false]}],
			['bold','italic','underline','strike',],
			['image', 'link'],
			[{list:'ordered'},{list:'bullet'}]
		]
	},
	   	theme: 'snow'
});
//에디터에 작성한 내용을 input요소로 변경
quill.on('text-change', function(delta, oldDelta, source){
	document.getElementById("quill_html").value = quill.root.innerHTML;
});

//HTML을 텍스트로 변환하는 함수
function htmlToText(html) {
    var tempDiv = document.createElement("div");
    tempDiv.innerHTML = html;
    return tempDiv.textContent || tempDiv.innerText || "";
}

//수정 전 양식
const initialData = {
	recruitTitle: '<%= recruit.getRecruitTitle() %>',
	content: '<%= recruit.getRecruitContent().replaceAll("\n", "\\n").replaceAll("\r", "\\r").replaceAll("\"", "\\\"") %>',  // 문자열 이스케이프
};
const beforeForm = () => {
	document.querySelector('[name="recruitTitle"]').value = initialData.recruitTitle;
	quill.clipboard.dangerouslyPasteHTML(initialData.content);  // HTML 콘텐츠를 그대로 설정
};
beforeForm();


function selectLocalImage(){
	const fileInput = document.createElement('input');
	fileInput.setAttribute('type', 'file');
	console.log("input.type" + fileInput.type);
	fileInput.click();
	
	
	fileInput.addEventListener("change", function(){
		const formData = new FormData();
		const file = fileInput.files[0];
		formData.append('uploadFile', file);
		
		$.ajax({
			type: 'POST',
			enctype: 'multipart/form-data',
			url: 'display', // 이미지 업로드를 처리할 서블릿 URL
			data: formData,
			processData: false,
			contentType: false,
			dataType: 'json',
			success: function(data){
				const range = quill.getSelection();
				const imageUrl = 'display?fileName=' + data.fileName;
				console.log("Inserting image at index: ", range.index, " with URL: ", imageUrl); // 디버그 로그
				quill.insertEmbed(range.index, 'image', imageUrl);
			},
			error: function(err){
				console.log(err);
			}
		});
	});
}

//Ajax 콜백 함수로 툴바의 이미지를 컨트롤함
quill.getModule('toolbar').addHandler('image', function(){
	selectLocalImage();
});
</script>

<footer class="fixed-bottom bg-dark text-center mt-5" style="color: #FFFFFF;">
    Copyright &copy; 2024 EhyunSeok All Rights Reserved.
</footer>

<script src="../js/jquery.min.js"></script>
<script src="../js/popper.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
</body>
</html>

