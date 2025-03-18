/**
 * Output object containing EC2 instance details.
 * Includes instance ID, private IP, and public IP (if applicable).
 */


output "ec2_details" {
  description = "output ec2 details"
  value = {
    instance_id = aws_instance.ec2.id
    private_ip  = aws_instance.ec2.private_ip
    public_ip   = var.public_subnet == true ? aws_instance.ec2.public_ip : "N/A"
    state       = aws_instance.ec2.instance_state
  }
}