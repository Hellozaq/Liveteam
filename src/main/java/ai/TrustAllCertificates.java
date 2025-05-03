package ai;

import javax.net.ssl.*;
import java.security.SecureRandom;
import java.security.cert.X509Certificate;

public class TrustAllCertificates {

    public static void trustAllCerts() throws Exception {
        // TrustManager que não valida os certificados
        TrustManager[] trustAllCerts = new TrustManager[]{
            new X509TrustManager() {
                public void checkClientTrusted(X509Certificate[] certs, String authType) {}
                public void checkServerTrusted(X509Certificate[] certs, String authType) {}
                public X509Certificate[] getAcceptedIssuers() { return new X509Certificate[0]; }
            }
        };

        // Criação do contexto SSL usando o TrustManager que aceita tudo
        SSLContext sc = SSLContext.getInstance("TLS");
        sc.init(null, trustAllCerts, new SecureRandom());

        // Define o SocketFactory padrão que ignora validações
        HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

        // Ignora verificação do nome do host (hostname verification)
        HttpsURLConnection.setDefaultHostnameVerifier(new HostnameVerifier() {
            public boolean verify(String hostname, SSLSession session) {
                return true;
            }
        });

        System.out.println("⚠️ TrustAllCertificates ativado (SSL INSEGURO)");
    }
}
