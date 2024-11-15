<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Formulário</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets\css\pages\faq-page.css">  
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets\css\style.css">  
        <%@ include file="WEB-INF/jspf/html-head.jspf" %>     
</head>
    <body>
         <%@ include file="WEB-INF/jspf/header.jspf" %>
         <div class="form-container">
         <h2>Preencha o Formulário</h2>
         
            <form action="GerarRespostaServlet" method="post">
                
                   <label for="nome">Nome:</label>
                   <input type="text" name="nome" id="nome" required><br>

                   <label for="email">Email:</label>
                   <input type="email" name="email" id="email" required><br>

                   <label for="mensagem">Mensagem:</label>
                   <textarea name="mensagem" id="mensagem" rows="4" required></textarea><br>

                <button type="submit">Gerar PDF com Resposta</button>
            </form>
         </div>
         
         <%@ include file="WEB-INF/jspf/footer.jspf" %>
    </body>
</html>
