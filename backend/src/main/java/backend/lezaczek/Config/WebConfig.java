package backend.lezaczek.Config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import backend.lezaczek.Interceptors.SessionHandler;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private SessionHandler sessionController;

    @Override
    public void addInterceptors(@NonNull InterceptorRegistry registry) {
        // registry.addInterceptor(sessionController).excludePathPatterns("/auth", "/auth/login", "/api/v1/auth", "/api/v1/auth/login");
    }
}