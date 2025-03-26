# Import packages for networks
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.optim import SGD

device = torch.device("cuda" if torch.cuda.is_available() else "cpu")

class BasicNN(nn.Module):
  def __init__(self):
    '''Define the layers of the network.'''
    super(BasicNN, self).__init__()
    # Layer 0 - Top Path
    self.w00 = nn.Parameter(torch.tensor(1.7), requires_grad=False)
    self.b00 = nn.Parameter(torch.tensor(-0.85), requires_grad=False)
    # Layer 0 - Bottom Path
    self.w01 = nn.Parameter(torch.tensor(12.6), requires_grad=False)
    self.b01 = nn.Parameter(torch.tensor(0.00), requires_grad=False)

    # Layer 1 - Top Path
    self.w10 = nn.Parameter(torch.tensor(-40.8), requires_grad=False)
    # Layer 1 - Bottom Path
    self.w11 = nn.Parameter(torch.tensor(2.7), requires_grad=False)

    # Final bias
    self.b_final = nn.Parameter(torch.tensor(0.00), requires_grad=True)

  def forward(self, input_value):
    '''Define the forward pass.'''
    # Top Path
    input_to_top_relu = input_value*self.w00 + self.b00
    top_relu_output = F.relu(input_to_top_relu)
    scaled_top_relu_output = top_relu_output*self.w10

    # Bottom Path
    input_to_bottom_relu = input_value*self.w01 + self.b01
    bottom_relu_output = F.relu(input_to_bottom_relu)
    scaled_bottom_relu_output = bottom_relu_output*self.w11

    # Converge throught final bias
    input_to_final_relu = scaled_top_relu_output + scaled_bottom_relu_output + self.b_final
    output = F.relu(input_to_final_relu)
    return output

# Implement Neuron
model = BasicNN().to(device)  

# Observed Data
stimuli = torch.tensor([0., 0.5, 1.])
response = torch.tensor([0., 1., 0.])

# Define the optimizer: Stochastic Gradient Descent
optimizer = SGD(model.parameters(), lr=0.1)
print("Final bias, before optimization: " + str(model.b_final.data) + "\n")

for epoch in range(100):
  total_loss = 0
  for iteration in range(len(stimuli)):
    stimuli_i, response_i = stimuli[iteration], response[iteration]
    output_i = model(stimuli_i)
    loss = (output_i - response_i)**2 # It's mean square error here, which batch size is 1.

    # Calculate gradient, here is only for b_final
    loss.backward()

    total_loss += float(loss)

  # Adapt b_final parameter
  optimizer.step()

  # Clear accumulated gradient and start another training loop.
  optimizer.zero_grad()

  # Observe the changes in "b_fianl" and the "loss" during each training epoch.
  print(f"Epoch {epoch+1} | Loss:{total_loss} | b_final: {str(model.b_final.detach())}")