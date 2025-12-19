/**
 * Output object containing EC2 instance details.
 * Includes instance ID, private IP, and public IP (if applicable).
 */


output "ec2_details" {
  description = "output ec2 details"
  value = var.spot_instance == false ? {
    instance_id = aws_instance.ec2[0].id
    private_ip  = aws_instance.ec2[0].private_ip
    public_ip   = var.public_subnet == true ? aws_instance.ec2[0].public_ip : "N/A"
    state       = aws_instance.ec2[0].instance_state
    billing      = "ondemand"
  } : {
    instance_id = aws_instance.ec2_spot[0].id
    private_ip  = aws_instance.ec2_spot[0].private_ip
    public_ip   = var.public_subnet == true ? aws_instance.ec2_spot[0].public_ip : "N/A"
    state       = aws_instance.ec2_spot[0].instance_state
    billing     = "spot"
  }
}