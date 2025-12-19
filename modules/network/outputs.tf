output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = aws_subnet.my_subnet_public.id 
}

output "private_subnet_ids" {
  value = [
    aws_subnet.my_subnet_private_a.id,
    aws_subnet.my_subnet_private_b.id
  ]
}

output "vpc_id_out" {
  value = aws_vpc.my_vpc.id
}