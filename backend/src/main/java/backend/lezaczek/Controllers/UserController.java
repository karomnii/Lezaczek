package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import backend.lezaczek.HttpInterfaces.ErrorResponse;
import backend.lezaczek.HttpInterfaces.Response;
import backend.lezaczek.Model.User;
import backend.lezaczek.Services.UserService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController
@RequestMapping("/user")
public class UserController {
    
    @Autowired
    UserService userService;

    @Autowired
    User currentUser;

    @PostMapping(path = "/delete", consumes ="application/json", produces = "application/json")
    public ResponseEntity<?> postMethodName(@RequestBody String entity) {
        Long userId = currentUser.getCurrentUser().getUserId();
        try {
            userService.deleteUser(userId);
        } catch (IllegalArgumentException e){
            return ResponseEntity.badRequest().body(new ErrorResponse("Cannot delete account"));
        }
        return ResponseEntity.ok(new Response("Account deleted"));
    }
}
