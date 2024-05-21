package backend.lezaczek.Interfaces;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import backend.lezaczek.Model.User;

@Repository
public interface UsersRepository extends JpaRepository<User, Long>{
    
}
