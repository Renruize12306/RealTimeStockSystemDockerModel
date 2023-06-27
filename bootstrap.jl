(pwd() != @__DIR__) && cd(@__DIR__) # allow starting app from bin/ dir

using RealTimeStockSystemDockerModel
const UserApp = RealTimeStockSystemDockerModel
RealTimeStockSystemDockerModel.main()
