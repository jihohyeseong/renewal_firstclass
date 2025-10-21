package com.example.renewal_firstclass.domain;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserDTO {
	
	private Long id;    
	private String name;
	private String registrationNumber;
	private String zipNumber;
	private String addressBase;
	private String addressDetail;
	private String username;
	private String phoneNumber;
	private String role;

}
