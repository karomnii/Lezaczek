package backend.lezaczek.Services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;

import backend.lezaczek.Model.User;
import backend.lezaczek.Repositories.UsersRepository;

@Service
public class AuthService {
    @Autowired
    private UsersRepository usersRepository;
    public Boolean authenticate(User user, String password) {

        return true;
    }
    
}
