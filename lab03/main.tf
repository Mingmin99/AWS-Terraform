# # NAT Gateway 생성 및 EIP 할당
# resource "aws_eip" "nat_eip_1" {
#   vpc = true
#   tags = {
#     Name = "nat-eip-1"
#   }
# }

# resource "aws_nat_gateway" "nat_gateway_1" {
#   allocation_id = aws_eip.nat_eip_1.id
#   subnet_id     = aws_subnet.public_subnet_1.id
#   tags = {
#     Name = "nat-gateway-1"
#   }
# }

# resource "aws_eip" "nat_eip_2" {
#   vpc = true
#   tags = {
#     Name = "nat-eip-2"
#   }
# }

# resource "aws_nat_gateway" "nat_gateway_2" {
#   allocation_id = aws_eip.nat_eip_2.id
#   subnet_id     = aws_subnet.public_subnet_2.id
#   tags = {
#     Name = "nat-gateway-2"
#   }
# }
