[English](https://github.com/michaelwade/ModularTradeSystem/blob/master/README.md)

[我的博客](https://blog.csdn.net/woshiwangbiao/article/details/106414608)

# 最近更新
- **Version 2.0**

	1. 重构了整个项目架构，使不同系统之间耦合度更低，两行代码就可以编译出不同的交易系统。
	2. 提供了一个新的交易系统，使用了马丁格尔策略。

![](https://github.com/michaelwade/ModularTradeSystem/blob/master/StrategyTester_water_martin.gif)
	
	
# 模块化交易系统

这是一个基于MQL4/MQL5的模块化交易系统模板。它包含多个常用模块，如交易系统控制中心，资金管理模块，订单管理模块...等等。模块化设计可以减少系统的耦合度，并且提高代码的可重用性。避免将所有代码放入一个文件中，可以使我们更专注于编写主要业务逻辑。下面是本交易系统的几大主要模块：

- **TradeSystemController**

	交易系统控制中心，这是整个交易系统的主要逻辑部分。该模块有一个抽象类CTradeSystemController，定义了几个最基本的虚函数，需要你自己去实现它们。主要包含处理原始信号数据，并结合其他数据进行综合分析，最后输出可执行的交易信号。如果你想自定义交易策略，可以重写这里的逻辑。
 
- **MoneyManager**

	资金管理模块，主要负责与资金有关的所有操作，例如检查余额，计算开平仓手数等。   

- **OrderManager**

	订单管理模块，主要提供与订单处理有关的一系列操作，例如开仓，平仓，检查空仓等。

- **SignalEngine**

 	信号引擎模块，该模块主要包含一个名为ISignalEngine的接口，你需要去实现它，并在实现类里封装原始信号的计算逻辑。值得一提的是，你可以同时实现多个信号引擎，比如一个使用MACD的信号，一个使用马丁策略信号，然后在自定义的TradeSystemController实现类里，综合这两个信号，最终输出一个可执行信号。

- **EnvChecker**

	运行环境检查模块，主要负责在交易之前检查运行环境，防止在诸如图表数据错误的情况下错误操作。只有当运行环境一切正常时才允许交易。

# 如何使用

1. **如何编译**

	在BuildConfig.mqh文件中，通过注释和非注释来选择你要编译的交易系统类型，然后编译即可。

1. **自定义信号引擎**

	自定义一个或多个类实现ISignalEngine接口，封装一个或多个指标的某种信号的计算逻辑。
	可以参考这个项目里三个已实现的信号引擎实例。

2. **自定义控制器**

	自定义一个类实现CTradeSystemController抽象类，在这个类里，你需要通过一个或多个信号引擎来获取原始信号数据，然后综合处理它们，最后输出可执行的交易信号。然后在控制器工厂类CTSControllerFactory中添加上你的自定义控制器,并在BuildConfig文件中添加上相应的预处理指令。

# 敬请期待
	
- **ExitManager**

	未来还会添加新的功能模块，比如可以设置或移动止损和止盈，暂且统称为退出管理模块。

- **......**

# 免责声明

需要注意的是，本交易系统仅供学习或参考之用，不能保证在交易实战中一定能稳定盈利。如果你一定要将其用于真仓交易，那么出现任何后果，我们概不负责。谢谢！









