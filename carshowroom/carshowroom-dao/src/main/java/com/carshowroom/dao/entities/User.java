package com.carshowroom.dao.entities;
import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;

//@NamedQuery(name = "User.findByUserName", query = "select u from User u where u.userName = :userName")

@Entity
@Table(name = "users")
public class User implements Serializable {
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "UsersID")
	private long usersID;
	
	@Column(name = "Name")
	private String name;
	
	@Column(name = "SurName")
	private String surName;
	
	/*@OneToMany(mappedBy = "GroupId", fetch = FetchType.LAZY)
	private List<>
	
	@OneToMany(mappedBy = "CarId", fetch = FetchType.LAZY)
	 private List<>
	
	@OneToMany(mappedBy = "Discount_Card_Id", fetch = FetchType.LAZY)
	private List<>*/
	
	@Column(name = "Password")
	private long password;
	
	public User(){
		super();
	}

	public long getUsersID() {
		return usersID;
	}

	public void setUsersID(long usersID) {
		this.usersID = usersID;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getSurName() {
		return surName;
	}

	public void setSurName(String surName) {
		this.surName = surName;
	}

	public long getPassword() {
		return password;
	}

	public void setPassword(long password) {
		this.password = password;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + (int) (password ^ (password >>> 32));
		result = prime * result + ((surName == null) ? 0 : surName.hashCode());
		result = prime * result + (int) (usersID ^ (usersID >>> 32));
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		User other = (User) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (password != other.password)
			return false;
		if (surName == null) {
			if (other.surName != null)
				return false;
		} else if (!surName.equals(other.surName))
			return false;
		if (usersID != other.usersID)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "User [usersID=" + usersID + ", name=" + name + ", surName=" + surName + ", password=" + password + "]";
	}

	
	
	
}
