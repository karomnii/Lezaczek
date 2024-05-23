package backend.lezaczek.Controllers;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import backend.lezaczek.Services.UserService;

@RestController
@RequestMapping("/login")
public class LoginController {
    @Autowired
    private UserService userService;
    @GetMapping(produces = "application/json", path = "/all")
    public Object getAllUsers(){
        System.out.println(userService.getAllUsers().stream().map(user -> user.toString()).toArray()[0]);
        return userService.getAllUsers().toString();
        }
    
}
