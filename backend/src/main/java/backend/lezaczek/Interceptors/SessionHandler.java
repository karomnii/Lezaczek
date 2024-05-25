package backend.lezaczek.Interceptors;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;


import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.ErrorResponse;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;



@Component
public class SessionHandler implements HandlerInterceptor {
    @Autowired
    JwtTokenHelper jwtTokenHelper;

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception{
        System.out.println("In preHandle");
        boolean isValidSession = checkSession(request, response);
        if (!isValidSession) {
            return false;
        }
        return true;
    }
    public boolean checkSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if(request.getCookies() != null){
            for (Cookie cookie : request.getCookies()){
                if(cookie.getName().equals("accessToken") || cookie.getName().equals("refreshToken")){
                    return isValidAccessToken(cookie.getValue(), response);
                }
            }
        }
        response.setStatus(HttpStatus.UNAUTHORIZED.value());
        response.getWriter().write(new ErrorResponse("Token not found").toJsonString());
        return false;
    }
    private boolean isValidAccessToken(String accessToken, HttpServletResponse response) throws IOException{
        if(jwtTokenHelper.isTokenExpired(accessToken)) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.getWriter().write(new ErrorResponse("Token expired").toJsonString());
            return false;
        };
        return true;
    }
}
