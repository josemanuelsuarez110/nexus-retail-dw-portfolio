import type { Metadata } from "next";
import { Inter } from "next/font/google";
import "./globals.css";

const inter = Inter({ subsets: ["latin"] });

export const metadata: Metadata = {
  title: "NexusRetail | Modern Data Warehouse Platform",
  description: "End-to-end data engineering portfolio project demonstrating Medallion Architecture, SCD Type 2, and advanced SQL analytics.",
  icons: {
    icon: "/favicon.ico",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className="h-full antialiased dark">
      <body className={`${inter.className} min-h-full flex flex-col bg-[#0a0a0c] text-[#f0f0f2]`}>
        {children}
      </body>
    </html>
  );
}
