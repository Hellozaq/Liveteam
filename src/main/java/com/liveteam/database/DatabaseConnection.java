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

                // Registrar o driver
                Class.forName(driver);

                // Estabelecer a conexão
                connection = DriverManager.getConnection(url, username, password);
                System.out.println("Conexão estabelecida com sucesso!");

            } catch (SQLException | ClassNotFoundException | IOException e) {
                e.printStackTrace();
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
                e.printStackTrace();
            }
        }
    }
}
