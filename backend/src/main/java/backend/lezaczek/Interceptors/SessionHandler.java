package backend.lezaczek.Interceptors;

import java.io.IOException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.Model.User;
import backend.lezaczek.Services.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class SessionHandler implements HandlerInterceptor {
    @Autowired
    JwtTokenHelper jwtTokenHelper;
    @Autowired
    UserService userService;
    @Autowired
    private User currentUser;

    @SuppressWarnings("null")
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {
        String token = getToken(request, "accessToken");
        if (!(token.length() > 0)) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.getWriter().write(new ErrorResponse("Token not found").toJsonString());
            return false;
        }
        if (!isValidToken(token, response)) {
            return false;
        }
        Long userId = jwtTokenHelper.extractUserId(token);
        Optional<User> user = userService.findById(userId);
        if (user.isEmpty()) {
            response.setStatus(HttpStatus.FORBIDDEN.value());
            response.getWriter().write(new ErrorResponse("No user matches given token").toJsonString());
            return false;
        }
        currentUser.setCurrentUser(user.get());
        return true;
    }

    public String getToken(HttpServletRequest request, String tokenName) {
        if (request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if (cookie.getName().equals(tokenName)) {
                    return cookie.getValue();
                }
            }
        }
        return "";
    }

    public boolean isValidToken(String token, HttpServletResponse response) throws IOException {
        if (jwtTokenHelper.isTokenExpired(token)) {
            response.setStatus(HttpStatus.UNAUTHORIZED.value());
            response.getWriter().write(new ErrorResponse("Token expired").toJsonString());
            return false;
        }
        ;
        return true;
    }
}