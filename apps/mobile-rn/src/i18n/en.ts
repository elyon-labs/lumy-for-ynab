/**
 * The English catalog, which is the only one.
 *
 * Nested by the domain that renders it, so a key reads as where it is used and
 * two screens cannot quietly share a string that then has to change in one
 * place and not the other.
 */
export const en = {
  common: {
    cancel: 'Cancel',
    done: 'Done',
    retry: 'Try again',
    unexpectedError: 'Something went wrong. Please try again.',
  },

  auth: {
    signIn: {
      title: 'Sign in',
      explainer:
        'Use the same email address on every device to sync what you set up in Lumy. None of the financial data fetched from YNAB leaves your device.',
      emailLabel: 'Email address',
      emailPlaceholder: 'you@example.com',
      submit: 'Email me a link',
      invalidEmail: 'Enter an email address.',
      sentTitle: 'Check your email',
      sentExplainer: 'Open the link in the email sent to {{email}} to finish signing in.',
      resend: 'Send another link',
      resendIn: 'You can send another link in {{seconds}}s',
      linkFailed: 'That link did not work. Send a new one and open it on this device.',
    },

    account: {
      title: 'Account',
      email: 'Email',
      pendingEmail: 'Waiting for confirmation',
      pendingEmailExplainer:
        'Open the link sent to {{email}} to finish changing your address. Until then, sign in with your old one.',
      changeEmail: 'Change email',
      signOut: 'Sign out',
      signOutConfirmTitle: 'Sign out of Lumy?',
      signOutConfirmMessage:
        'What you set up in Lumy stays in your account. Your YNAB data is removed from this device.',
      deleteAccount: 'Delete account',
      deleteConfirmTitle: 'Delete your account?',
      deleteConfirmMessage:
        'This removes your account and everything you set up in Lumy — category views, spend trackers, frugal months, and templates. Your YNAB budget is untouched. This cannot be undone.',
      deleteConfirm: 'Delete account',
      deleteFailed: 'Your account was not deleted. Please try again.',
    },

    ynab: {
      connectTitle: 'Connect YNAB',
      connectExplainer:
        'Lumy reads your YNAB budget to show you where your money goes. Connecting uses OAuth, so YNAB never shares your password with Lumy.',
      connectNote: 'You will be taken to YNAB to approve it, then brought back here.',
      connect: 'Connect YNAB account',
      connectFailed: 'YNAB could not be connected. Please try again.',
      disconnect: 'Disconnect YNAB',
      readOnly: 'Read only',
      canWrite: 'Read and write',

      writeAccessTitle: 'Just a sec',
      writeAccessExplainer:
        'Before Lumy can create transactions, YNAB needs your permission to write to your budget. Lumy will never write to your budget without being asked.',
      grantWriteAccess: 'Grant write access',
      grantWriteAccessFailed: 'Write access was not granted. Please try again.',
    },

    changeEmail: {
      title: 'Change email',
      explainer:
        'We will email the new address to confirm it. Your address changes once you open that link.',
      emailLabel: 'New email address',
      submit: 'Send confirmation',
      sameAsCurrent: 'That is already your email address.',
      sentTitle: 'Check your email',
      sentExplainer: 'Open the link sent to {{email}} to confirm the change.',
    },
  },
} as const;

export type Catalog = typeof en;
