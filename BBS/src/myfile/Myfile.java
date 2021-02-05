package myfile;

public class Myfile {
	private String userID;
	private String fileName; // 서버에 저장된 실제 파일의 이름 - 중복된 이름의 파일이 업로드될 때 임의로 변경해줘야 함
	private String fileRealName; // 사용자가 저장한 파일의 이름 - 다시 저장할 때는 원래 이름으로 저장되어야 함
	private String uploadDate;
	
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFileRealName() {
		return fileRealName;
	}
	public void setFileRealName(String fileRealName) {
		this.fileRealName = fileRealName;
	}
	public String getUploadDate() {
		return uploadDate;
	}
	public void setUploadDate(String uploadDate) {
		this.uploadDate = uploadDate;
	}

}
