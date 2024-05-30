package backend.lezaczek.Config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import backend.lezaczek.Interceptors.SessionHandler;

@Configuration
@EnableWebMvc
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    SessionHandler sessionHandler;

    @Override
    public void addInterceptors(@NonNull InterceptorRegistry registry) {
        // comment out this line to disable session checking
        registry.addInterceptor(sessionHandler).excludePathPatterns("/register",
                "/login",
                "/refresh",
                "/hello",
                "/auth/register",
                "/auth/login",
                "/auth/refresh",
                "/api/v1/auth/refresh");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry){
        registry.addMapping("/**");

    }
}