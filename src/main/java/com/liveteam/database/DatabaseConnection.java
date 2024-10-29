package com.liveteam.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.io.IOException;
import java.util.Properties;

public class DatabaseConnection {

    private static Connection connection = null;

    public static Connection getConnection() {
        if (connection == null) {
            try {
                Properties props = new Properties();
                // Carregar o arquivo db.properties localizado em src/main/resources
                props.load(DatabaseConnection.class.getClassLoader().getResourceAsStream("db.properties"));

                String url = props.getProperty("db.url");
                String username = props.getProperty("db.username");
                String password = props.getProperty("db.password");
                String driver = props.getProperty("db.driver");

                // Adicione logs para verificar se as propriedades foram carregadas corretamente
                System.out.println("URL: " + url);
                System.out.println("Username: " + username);
                System.out.println("Driver: " + driver);
            
                // Registrar o driver
                Class.forName(driver);

                // Estabelecer a conexão em uma linha
                connection = DriverManager.getConnection(url, username, password);
                
                if (connection != null) {
                    System.out.println("Conexão estabelecida com sucesso!");
                } else {
                    System.out.println("Falha ao estabelecer a conexão.");
                }
            } catch (SQLException e) {
                System.err.println("Erro ao conectar ao banco de dados: " + e.getMessage());
                throw new RuntimeException("Falha na conexão com o banco de dados", e);
            } catch (ClassNotFoundException e) {
                System.err.println("Driver JDBC não encontrado: " + e.getMessage());
                throw new RuntimeException("Driver JDBC não encontrado", e);
            } catch (IOException e) {
                System.err.println("Erro ao carregar o arquivo de propriedades: " + e.getMessage());
                throw new RuntimeException("Erro ao carregar o arquivo de propriedades", e);
            }
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                System.out.println("Conexão fechada com sucesso!");
            } catch (SQLException e) {
                System.err.println("Erro ao fechar a conexão: " + e.getMessage());
            }
        }
    }
}
