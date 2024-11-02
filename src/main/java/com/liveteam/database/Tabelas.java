package com.liveteam.database;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

public class Tabelas {

    public static void main(String[] args) {
        // Estabelece a conexão diretamente com o banco de dados Liveteam
        try (Connection connection = DatabaseConnection.getConnection();
             Statement statement = connection.createStatement()) {

            // Cria a tabela de Usuários
            statement.executeUpdate("CREATE TABLE IF NOT EXISTS usuario (" +
                                    "id SERIAL PRIMARY KEY, " +
                                    "nome VARCHAR(50) NOT NULL, " +
                                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                                    "senha VARCHAR(50) NOT NULL)");

            System.out.println("Tabela de usuários criada com sucesso no banco de dados Liveteam!");

        } catch (SQLException e) {
            System.err.println("Erro ao executar comandos SQL: " + e.getMessage());
        } finally {
            DatabaseConnection.closeConnection();
        }
    }
}
