package servlets;

import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import javax.net.ssl.*;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;
import javax.net.SocketFactory;

public class TrustAllSSLSocketFactory extends SSLSocketFactory {
    private SSLSocketFactory factory;

    public TrustAllSSLSocketFactory() {
        try {
            SSLContext ctx = SSLContext.getInstance("TLS");
            ctx.init(null, new TrustManager[]{new X509TrustManager() {
                @Override
                public void checkClientTrusted(X509Certificate[] xcs, String string) {}
                @Override
                public void checkServerTrusted(X509Certificate[] xcs, String string) {}
                @Override
                public X509Certificate[] getAcceptedIssuers() { return null; }
            }}, new SecureRandom());
            factory = ctx.getSocketFactory();
        } catch (KeyManagementException | NoSuchAlgorithmException ex) {
            throw new RuntimeException(ex);
        }
    }

    public static SocketFactory getDefault() {
        return new TrustAllSSLSocketFactory();
    }

    @Override
    public String[] getDefaultCipherSuites() {
        return factory.getDefaultCipherSuites();
    }

    @Override
    public String[] getSupportedCipherSuites() {
        return factory.getSupportedCipherSuites();
    }

    @Override
    public java.net.Socket createSocket(java.net.Socket socket, String host, int port, boolean autoClose) throws java.io.IOException {
        return factory.createSocket(socket, host, port, autoClose);
    }

    @Override
    public java.net.Socket createSocket(String host, int port) throws java.io.IOException {
        return factory.createSocket(host, port);
    }

    @Override
    public java.net.Socket createSocket(String host, int port, java.net.InetAddress localHost, int localPort) throws java.io.IOException {
        return factory.createSocket(host, port, localHost, localPort);
    }

    @Override
    public java.net.Socket createSocket(java.net.InetAddress host, int port) throws java.io.IOException {
        return factory.createSocket(host, port);
    }

    @Override
    public java.net.Socket createSocket(java.net.InetAddress address, int port, java.net.InetAddress localAddress, int localPort) throws java.io.IOException {
        return factory.createSocket(address, port, localAddress, localPort);
    }
}