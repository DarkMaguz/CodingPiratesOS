#include <limits.h>
#include <gtest/gtest.h>

#include "ImageDownloader.h"

//TEST(ImageDownloader, progress)
//{
//	ImageDownloader id;
//	double progress = id.Progress();
//	EXPECT_EQ(progress, 0.0);
//}
//
//void notifyCallback(void)
//{
//	std::cout << "notifyCallback" << std::endl;
//}
//
//TEST(ImageDownloader, Download)
//{
//	ImageDownloader id;
//	const std::string target = "https://darkmagus.dk/dark-wizard-hd-wallpaper-picture-w5y.jpg";
//
//	/*auto notifyCallback = [id](){
//		EXPECT_GT(id.Progress(), 0.0);
//	};*/
//
////	id.Download(target, notifyCallback);
//
//	//EXPECT_EQ(progress, 0.0);
//}

int main(int argc, char **argv)
{
	testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}
