package backend.lezaczek.Interceptors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


@Component
public class SessionHandler implements HandlerInterceptor {


    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception{
        boolean isValidSession = checkSession(request);
        System.out.println("In preHandle");
        if (!isValidSession) {
            // response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            // response.setContentType("application/json");
            // response.getWriter().write("{\"error\": \"Invalid session\"}");
            // response.getWriter().flush();
            return false;
        }
        return true;
    }
    private boolean checkSession(HttpServletRequest request) {
        String userToken = request.getHeader("User-Token");
        if (userToken != null) {
        }
        return false;
    }
}
