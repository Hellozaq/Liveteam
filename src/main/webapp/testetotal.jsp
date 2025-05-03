<%@ page contentType="text/html; charset=UTF-8" %>
<html>
<head>
    <title>Upload de Imagem</title>
    <script>
        function uploadImage() {
            let formData = new FormData(document.getElementById("uploadForm"));
            
            fetch("ImageAnalysisServlet", {
                method: "POST",
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById("result").value = data.response;
            })
            .catch(error => {
                document.getElementById("result").value = "Erro ao processar a imagem.";
            });
        }
    </script>
</head>
<body>
    <h2>Envie uma imagem para análise</h2>
    <form id="uploadForm" enctype="multipart/form-data">
        <input type="file" name="image" accept="image/*" onchange="uploadImage()" required>
    </form>
    <h2>Resultado:</h2>
    <textarea id="result" rows="5" cols="50"></textarea>
    

</body>
</html>