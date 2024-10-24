function validarSenhas(event) {
                const senha1 = document.getElementById('senha1').value;
                const senha2 = document.getElementById('senha2').value;

                if (senha1 !== senha2) {
                    event.preventDefault();  // Impede o envio do formulário
                    alert("As senhas não correspondem. Por favor, tente novamente.");
                }
            }

            document.addEventListener("DOMContentLoaded", function() {
                const form = document.querySelector('form');
                form.addEventListener('submit', validarSenhas);
            });
       