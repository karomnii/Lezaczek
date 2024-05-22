package backend.lezaczek;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class LezaczekApplication {
    public static void main(String[] args) {
        System.setProperty("server.servlet.context-path", "/api/v1");
        SpringApplication.run(LezaczekApplication.class, args);
    }
}