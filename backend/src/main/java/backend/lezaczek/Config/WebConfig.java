package backend.lezaczek.Config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import backend.lezaczek.Controllers.SessionController;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Autowired
    private SessionController sessionController;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(sessionController).excludePathPatterns("/login", "/login/**");
    }
}