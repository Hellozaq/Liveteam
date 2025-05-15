package com.liveteam.database;

import java.sql.*;
import java.util.*;
import java.io.IOException;
import java.util.Properties;

import org.mindrot.jbcrypt.BCrypt;

public class DatabaseConnection {

    private static Connection connection = null;

    /**
     * Retorna uma única instância de Connection (Singleton).
     * @return
     */
    public static synchronized Connection getConnection() {
        if (connection == null) {
            try {
                Properties props = new Properties();
                props.load(DatabaseConnection.class
                                             .getClassLoader()
                                             .getResourceAsStream("db.properties"));

                String url     = props.getProperty("db.url");
                String user    = props.getProperty("db.username");
                String pass    = props.getProperty("db.password");
                String driver = props.getProperty("db.driver");

                Class.forName(driver);
                connection = DriverManager.getConnection(url, user, pass);

            } catch (IOException | ClassNotFoundException | SQLException e) {
                throw new RuntimeException("Falha na configuração ou conexão com o banco", e);
            }
        }
        return connection;
    }

    /**
     * Fecha a conexão única se ela existir.
     */
    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ignored) {}
            finally {
                connection = null;
            }
        }
    }

    /**
     * Adiciona um novo usuário, hashando a senha com BCrypt.
     */
    public static void addUser(String nome, String email, String senhaPlain, String role) throws SQLException {
        String sql = "INSERT INTO usuario (nome, email, senha, role) VALUES (?, ?, ?, ?)";
        String hashed = BCrypt.hashpw(senhaPlain, BCrypt.gensalt());

        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, nome);
            ps.setString(2, email);
            ps.setString(3, hashed);
            ps.setString(4, role);
            ps.executeUpdate();
        }
    }

    /**
     * Remove um usuário pelo ID.
     * @param userId
     * @throws java.sql.SQLException
     */
    public static void deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM usuario WHERE id = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    /**
     * Retorna todos os usuários com paginação (sem expor senhas).
     * @param limit
     * @param offset
     * @return 
     * @throws java.sql.SQLException
     */
        public static List<User> getAllUsers(int limit, int offset, String sortBy, String order) throws SQLException {
            List<User> users = new ArrayList<>();
            StringBuilder sql = new StringBuilder("SELECT id, nome, role, email FROM usuario");

            if (sortBy != null && !sortBy.isEmpty()) {
                sql.append(" ORDER BY ").append(sortBy);
                if (order != null && order.equalsIgnoreCase("desc")) {
                    sql.append(" DESC");
                } else {
                    sql.append(" ASC"); // Por padrão, ordena ascendente
                }
            }

            sql.append(" LIMIT ? OFFSET ?");

            String finalSql = sql.toString();
            System.out.println("SQL: " + finalSql); // Para depuração

            try (PreparedStatement ps = getConnection().prepareStatement(finalSql)) {
                ps.setInt(1, limit);
                ps.setInt(2, offset);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        users.add(new User(
                                rs.getInt("id"),
                                rs.getString("nome"),
                                rs.getString("role"),
                                rs.getString("email")
                        ));
                    }
                }
            }
            return users;
        }

        // Sobrecarga para a chamada original sem ordenação
        public static List<User> getAllUsers(int limit, int offset) throws SQLException {
            return getAllUsers(limit, offset, null, null);
        }

    /**
     * Retorna o total de usuários cadastrados.
     */
    public static int getTotalUserCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM usuario";
        try (PreparedStatement ps = getConnection().prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    /**
     * Atualiza informações do usuário.
     */
    public static void updateUser(int userId, String nome, String email, String senhaPlain, String role) throws SQLException {
        StringBuilder sql = new StringBuilder("UPDATE usuario SET nome = ?, email = ?, ");
        boolean updateSenha = (senhaPlain != null && !senhaPlain.isEmpty());

        if (updateSenha) {
            sql.append("senha = ?, ");
        }

        sql.append("role = ? WHERE id = ?");

        try (PreparedStatement ps = getConnection().prepareStatement(sql.toString())) {
            int i = 1;
            ps.setString(i++, nome);
            ps.setString(i++, email);
            if (updateSenha) {
                String hashed = BCrypt.hashpw(senhaPlain, BCrypt.gensalt());
                ps.setString(i++, hashed);
            }
            ps.setString(i++, role);
            ps.setInt(i, userId);

            ps.executeUpdate();
        }
    }

    /**
     * Busca o papel (role) de um usuário pelo e-mail.
     */
    public static String getUserRole(String email) throws SQLException {
        String sql = "SELECT role FROM usuario WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("role");
                }
            }
        }
        return null;
    }

    /**
     * Verifica se a senha em texto confere com o hash armazenado.
     */
    public static boolean verifyUser(String email, String senhaPlain) throws SQLException {
        String sql = "SELECT senha FROM usuario WHERE email = ?";
        try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashed = rs.getString("senha");
                    return BCrypt.checkpw(senhaPlain, hashed);
                }
            }
        }
        return false;
    }

    /**
     * Representa um usuário sem expor a senha.
     */
    public static class User {
        public final int id;
        public final String nome;
        public final String role;
        public final String email;

        public User(int id, String nome, String role, String email) {
            this.id    = id;
            this.nome = nome;
            this.role = role;
            this.email = email;
        }
    }
}