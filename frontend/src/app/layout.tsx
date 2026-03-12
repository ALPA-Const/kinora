import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Kinora — Your kin. Always close.',
  description:
    'Kinora is a private family communication platform exclusively for invited family members.',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}): React.JSX.Element {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}
