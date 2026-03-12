import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Enter Your Family Code — Kinora',
};

export default function HomePage(): React.JSX.Element {
  return (
    <main
      style={{
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
        minHeight: '100vh',
        fontFamily: 'system-ui, sans-serif',
      }}
    >
      <h1>Kinora</h1>
      <p>
        <em>Your kin. Always close.</em>
      </p>
      <p>Enter your family invite code to get started.</p>
      {/* TODO: Replace with LicenseCodeEntry component */}
    </main>
  );
}
