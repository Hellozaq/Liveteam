package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/ObterDadosDiariosServlet")
public class ObterDadosDiarios extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String dia = request.getParameter("dia");
        String mes = request.getParameter("mes");
        String ano = request.getParameter("ano");

        try (PrintWriter out = response.getWriter()) {
            try (Connection conn = com.liveteam.database.DatabaseConnection.getConnection()) {
                String sql = "SELECT * FROM dados_diarios WHERE dia = ? AND mes = ? AND ano = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(dia));
                    ps.setInt(2, Integer.parseInt(mes));
                    ps.setInt(3, Integer.parseInt(ano));

                    try (ResultSet rs = ps.executeQuery()) {
                        out.println("<html>");
                        out.println("<head><title>Informações Diárias</title></head>");
                        out.println("<body>");
                        out.println("<h1>Informações para o dia " + dia + "/" + mes + "/" + ano + "</h1>");

                        if (rs.next()) {
                            out.println("<h2>Alimentação</h2>");
                            out.println("<ul>");
                            out.println("<li><strong>Café da Manhã:</strong> " + rs.getString("cafe_da_manha") + "</li>");
                            out.println("<li><strong>Almoço:</strong> " + rs.getString("almoco") + "</li>");
                            out.println("<li><strong>Jantar:</strong> " + rs.getString("jantar") + "</li>");
                            out.println("<li><strong>Lanches:</strong> " + rs.getString("lanches") + "</li>");
                            out.println("<li><strong>Observações:</strong> " + rs.getString("observacoes_alimentacao") + "</li>");
                            out.println("</ul>");

                            out.println("<h2>Líquidos</h2>");
                            out.println("<ul>");
                            out.println("<li><strong>Água:</strong> " + rs.getString("agua") + "</li>");
                            out.println("<li><strong>Outros Líquidos:</strong> " + rs.getString("outros_liquidos") + "</li>");
                            out.println("<li><strong>Observações:</strong> " + rs.getString("observacoes_liquidos") + "</li>");
                            out.println("</ul>");

                            out.println("<h2>Exercícios</h2>");
                            out.println("<ul>");
                            out.println("<li><strong>Tipo de Treino:</strong> " + rs.getString("tipo_treino") + "</li>");
                            out.println("<li><strong>Duração:</strong> " + rs.getString("duracao") + "</li>");
                            out.println("<li><strong>Intensidade:</strong> " + rs.getString("intensidade") + "</li>");
                            out.println("<li><strong>Detalhes:</strong> " + rs.getString("detalhes") + "</li>");
                            out.println("<li><strong>Observações:</strong> " + rs.getString("observacoes_exercicios") + "</li>");
                            out.println("</ul>");

                            out.println("<h2>Avaliação</h2>");
                            out.println("<ul>");
                            out.println("<li><strong>Nível de Fome:</strong> " + rs.getString("nivel_fome") + "</li>");
                            out.println("<li><strong>Nível de Energia:</strong> " + rs.getString("nivel_energia") + "</li>");
                            out.println("<li><strong>Qualidade do Sono:</strong> " + rs.getString("qualidade_sono") + "</li>");
                            out.println("<li><strong>Observações:</strong> " + rs.getString("observacoes_avaliacao") + "</li>");
                            out.println("</ul>");
                        } else {
                            out.println("<p>Não há informações para a data selecionada.</p>");
                        }

                        out.println("</body>");
                        out.println("</html>");
                    }
                }
            } catch (Exception e) {
                out.println("<p>Erro ao obter informações do banco de dados.</p>");
            }
        }
    }
}
