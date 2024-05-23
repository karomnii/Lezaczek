package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.function.ServerRequest.Headers;

import backend.lezaczek.Helpers.JwtTokenHelper;
import backend.lezaczek.HttpInterfaces.AuthResponse;
import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.LoginRequest;
import backend.lezaczek.Model.User;
import backend.lezaczek.Services.AuthService;
import backend.lezaczek.Services.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController
@RequestMapping("/auth")
public class AuthController {
    @Autowired
    private UserService userService;
    @Autowired
    private AuthService authService;
    @Autowired
    JwtTokenHelper jwtTokenHelper;

    private static final long ACCESS_TOKEN_EXPIRATION = 1000 * 60 * 15; // 15 minutes
    private static final long REFRESH_TOKEN_EXPIRATION = 1000 * 60 * 60 * 24 * 7; // 7 days
    
    @PostMapping(value = "/login", produces = {"application/json"}, consumes = {"application/x-www-form-urlencoded", "application/json"})
    public ResponseEntity<?> login(LoginRequest LoginRequest, HttpServletRequest request, HttpServletResponse response) throws Exception {
        response.setContentType("application/json");
        //TODO: process POST request
        System.out.println(LoginRequest.getEmail());
        System.out.println(LoginRequest.getPassword());
        User user;
        try {
            user = userService.findByEmail(LoginRequest.getEmail());
        }
        catch (Exception e) {
            
            return ResponseEntity.ok(new ErrorResponse("Invalid password or user not found"));
        }
        Boolean isSuccessfulLogin = authService.authenticate(user, LoginRequest.getPassword());
        if (!isSuccessfulLogin) {
            return ResponseEntity.ok(new ErrorResponse("Invalid password or user not found"));
        }
        String accessToken = jwtTokenHelper.generateToken(String.valueOf(user.getUserId()), ACCESS_TOKEN_EXPIRATION);
        String refreshToken = jwtTokenHelper.generateToken(String.valueOf(user.getUserId()), REFRESH_TOKEN_EXPIRATION);
        Cookie refreshTokenCookie = new Cookie("refreshToken", refreshToken);
        refreshTokenCookie.setHttpOnly(true);
        refreshTokenCookie.setSecure(true);
        refreshTokenCookie.setPath("/");
        refreshTokenCookie.setMaxAge((int) REFRESH_TOKEN_EXPIRATION / 1000);
        response.addCookie(refreshTokenCookie);
        
        return ResponseEntity.ok(new AuthResponse(accessToken));
    }
    
}
